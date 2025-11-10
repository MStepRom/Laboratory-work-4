package org.example;

/**
 * Головний клас для програми CalmLight Project Manager.
 */
public class Main {

    // Приватний конструктор, щоб заборонити створення екземплярів цього службового класу
    private Main() {
        throw new UnsupportedOperationException("Це службовий клас і не повинен мати екземплярів");
    }

    /**
     * Головна точка входу в програму.
     *
     * @param args Аргументи командного рядка.
     */
    public static void main(final String[] args) {
        System.out.printf("CalmLight Project Manager");
    }
}
