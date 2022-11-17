#include <random>
#include "pch.h"
#include "Utilities.h"


// https://inversepalindrome.com/blog/how-to-create-a-random-string-in-cpp
std::string Utilities::random_string(std::size_t aLength)
{
    const std::string CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

    std::random_device random_device;
    std::mt19937 generator(random_device());
    std::uniform_int_distribution<> distribution(0, CHARACTERS.size() - 1);

    std::string random_string;

    for (std::size_t i = 0; i < aLength; ++i)
    {
        random_string += CHARACTERS[distribution(generator)];
    }

    return random_string;
}