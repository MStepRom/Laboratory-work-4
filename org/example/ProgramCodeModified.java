package org.example;

/**
 * Головний клас для програми CalmLight Project Manager.
 */
public final class Main {

    // Приватний конструктор, щоб заборонити створення екземплярів цього класу
    private Main() {
        throw new UnsupportedOperationException("Це службовий клас");
    }

    /**
     * Головна точка входу в програму.
     * @param args Аргументи командного рядка.
     */
    public static void main(final String[] args) {
        System.out.printf("CalmLight Project Manager");
    }
}
