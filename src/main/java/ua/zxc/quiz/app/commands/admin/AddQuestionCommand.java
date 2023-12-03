package ua.zxc.quiz.app.commands.admin;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import okhttp3.*;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import ua.zxc.quiz.app.commands.Command;
import ua.zxc.quiz.app.web.Page;
import ua.zxc.quiz.dao.IrisDaoFactory;
import ua.zxc.quiz.dao.entity.AnswersDAO;
import ua.zxc.quiz.dao.entity.QuestionDAO;
import ua.zxc.quiz.dao.entity.QuizDAO;
import ua.zxc.quiz.dao.entity.VariantsDAO;
import ua.zxc.quiz.dao.model.Question;
import ua.zxc.quiz.dao.model.Quiz;
import ua.zxc.quiz.exception.DbException;

import java.io.IOException;
import java.util.*;
import java.util.concurrent.TimeUnit;

public class AddQuestionCommand implements Command {

    private static final Logger LOGGER = LogManager.getLogger(AddQuestionCommand.class);

    private final QuizDAO quizDAO;

    private final QuestionDAO questionDAO;

    private final VariantsDAO variantsDAO;

    private final AnswersDAO answersDAO;

    private static final String API_KEY;

    static {
        ResourceBundle resource = ResourceBundle.getBundle("chatgpt");
        API_KEY = resource.getString("api-key");
    }

    public AddQuestionCommand() {
        IrisDaoFactory irisDAOFactory = new IrisDaoFactory();
        questionDAO = irisDAOFactory.getQuestionDAO();
        variantsDAO = irisDAOFactory.getVariantsDAO();
        answersDAO = irisDAOFactory.getAnswersDAO();
        quizDAO = irisDAOFactory.getQuizDAO();
    }

    @Override
    public Page execute(HttpServletRequest request, HttpServletResponse response) {
        if (request.getMethod().equalsIgnoreCase("get")) {
            if (Boolean.parseBoolean(request.getParameter("gpt"))) {
                getQuestionFromChatGPT(request);
            }
            return new Page("/WEB-INF/jsp/admin/add-question.jsp", false);
        }
        String prompt = request.getParameter("prompt");
        List<String> variants = setVariants(request);
        List<Character> answers = setAnswers(request);
        if (!validateValues(prompt, variants, answers)) {
            return new Page("/admin/add-question?id=" + request.getParameter("id") + "&error=true", true);
        }
        try {
            long quizId = Long.parseLong(request.getParameter("id"));
            Question question = questionDAO.insert(Question.createQuestion(prompt, variants, answers), quizId);
            variantsDAO.insert(question);
            answersDAO.insert(question);
            return new Page("/admin/quizzes/questions?id=" + quizId, true);
        } catch (DbException e) {
            LOGGER.error(e);
            return new Page("/admin/add-question?id=" + request.getParameter("id") + "&error=true", true);
        }
    }

    private void getQuestionFromChatGPT(HttpServletRequest request) {
        OkHttpClient okHttpClient = new OkHttpClient.Builder()
                .connectTimeout(10, TimeUnit.MINUTES)
                .writeTimeout(10, TimeUnit.MINUTES)
                .readTimeout(10, TimeUnit.MINUTES)
                .callTimeout(10, TimeUnit.MINUTES)
                .build();
        String prompt;
        try {
            Quiz quiz = quizDAO.get(Long.parseLong(request.getParameter("id")));
            String quizName = quiz.getName();
            String difficulty = quiz.getDifficulty();
            prompt = "Generate question on the topic '" + quizName + "' by difficulty '" + difficulty + "'. With this template: Question. a answer: b answer: c answer: d answer: Correct answer: *letter of correct answer*";
        } catch (DbException e) {
            throw new RuntimeException(e);
        }
        String requestData = "{\"model\": \"gpt-3.5-turbo\", \"messages\": [{\"role\": \"system\", \"content\": \"You are a helpful assistant.\"}, {\"role\": \"user\", \"content\": \"" + prompt + "\"}]}";
        MediaType mediaType = MediaType.parse("application/json");
        RequestBody body = RequestBody.create(mediaType, requestData);

        Request gptRequest = new Request.Builder()
                .url("https://api.openai.com/v1/chat/completions")
                .addHeader("Authorization", "Bearer " + API_KEY)
                .addHeader("Content-Type", "application/json")
                .post(body)
                .build();

        try (Response gptResponse = okHttpClient.newCall(gptRequest).execute()) {
            if (gptResponse.isSuccessful()) {
                parseQuestionFromChatGPT(request, gptResponse);
            }
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    private void parseQuestionFromChatGPT(HttpServletRequest request, Response gptResponse) throws IOException {
        String responseBody = gptResponse.body().string();
        String text = extractMessageFromJSONResponse(responseBody);
        String[] split = text.split("\\\\n");
        String question = "";
        Map<Character, String> answers = new HashMap<>();
        char answer = 'a';
        char letter = 'a';
        for (String s : split) {
            if (s.startsWith("Question:")) {
                question = s.substring(9).trim();
            } else if (s.startsWith(letter + ")")) {
                answers.put(letter, s.substring(2).trim());
                letter++;
            } else if (s.startsWith("Correct answer")) {
                answer = s.substring(15).trim().charAt(0);
            }
        }
        request.setAttribute("question", question);
        request.setAttribute("answers", answers);
        request.setAttribute("answer", answer);
    }

    public String extractMessageFromJSONResponse(String response) {
        int start = response.indexOf("content") + 11;
        int end = response.indexOf("\"", start);
        return response.substring(start, end);
    }

    private List<Character> setAnswers(HttpServletRequest request) {
        List<Character> answers = new ArrayList<>();
        for (int i = 0; i < 4; i++) {
            char letter = (char) ('a' + i);
            String answer = request.getParameter(String.valueOf(letter));
            if (answer != null) {
                answers.add(letter);
            }
        }
        return answers;
    }

    private List<String> setVariants(HttpServletRequest request) {
        List<String> variants = new ArrayList<>();
        for (char i = 0; i < 4; i++) {
            char letter = (char) ('a' + i);
            String variant = request.getParameter(letter + "-input");
            if (variant == null) {
                break;
            }
            if (!variant.isEmpty()) {
                variants.add(variant);
            }
        }
        return variants;
    }

    private boolean validateValues(String prompt, List<String> variants, List<Character> answers) {
        if (prompt.isEmpty()) {
            return false;
        }

        if (variants.isEmpty()) {
            return false;
        }

        return !answers.isEmpty();
    }
}
