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
package org.pgpainless.key.protection;



import org.bouncycastle.openpgp.operator.PBESecretKeyDecryptor;
import org.bouncycastle.openpgp.operator.PBESecretKeyEncryptor;

/**
 * Implementation of the {@link SecretKeyRingProtector} which assumes that all handled keys are not password protected.
 */
public class UnprotectedKeysProtector implements SecretKeyRingProtector {

    @Override

    public PBESecretKeyDecryptor getDecryptor(Long keyId) {
        return null;
    }

    @Override

    public PBESecretKeyEncryptor getEncryptor(Long keyId) {
        return null;
    }
}
