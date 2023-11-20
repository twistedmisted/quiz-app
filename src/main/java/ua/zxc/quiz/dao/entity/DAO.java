package ua.zxc.quiz.dao.entity;

import ua.zxc.quiz.exception.DbException;

import java.util.List;

public interface DAO<T> {

    T get(long id) throws DbException;

    List<T> getAll() throws DbException;

    T insert(T t) throws DbException;

    void update(T t) throws DbException;

    void delete(T t) throws DbException;
}
