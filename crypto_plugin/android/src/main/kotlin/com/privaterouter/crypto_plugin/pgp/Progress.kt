package com.privaterouter.crypto_plugin.pgp


class Progress(var total: Long = -1,
               var current: Long = 0,
               var complete: Boolean = false)