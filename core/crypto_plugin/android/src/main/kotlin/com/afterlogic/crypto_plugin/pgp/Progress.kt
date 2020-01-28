package com.afterlogic.crypto_plugin.pgp


class Progress(var total: Long = -1,
               var complete: Boolean = false,
               var stop: Boolean = false) {
    var current: Long = 0
        private set

    fun update(current: Int) {
        if (stop) {
            throw Throwable("canceled")
        }
        this.current += current
    }
}