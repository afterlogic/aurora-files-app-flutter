package com.afterlogic.crypto_plugin.pgp

open class PgpError(message: String, val case: ErrorCase) : Throwable(message)

enum class ErrorCase {
    Sign, Input
}

class SignError : PgpError("check sign assert error", ErrorCase.Sign)

class InputDataError : PgpError("invalid input data", ErrorCase.Input)