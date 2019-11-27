/*
 * Copyright 2018 Paul Schaub.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.pgpainless.key.selection.key.impl;



import org.bouncycastle.openpgp.PGPPublicKey;
import org.pgpainless.key.selection.key.PublicKeySelectionStrategy;

/**
 * Key Selection Strategy that only accepts {@link PGPPublicKey}s which are capable of encryption.
 *
 * @param <O> Type that describes the owner of the key (not used for decision).
 */
public class EncryptionKeySelectionStrategy<O> extends PublicKeySelectionStrategy<O> {

    @Override
    public boolean accept(O identifier,  PGPPublicKey key) {
        return key.isEncryptionKey();
    }
}
