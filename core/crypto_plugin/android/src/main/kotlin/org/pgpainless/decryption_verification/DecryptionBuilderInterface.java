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
package org.pgpainless.decryption_verification;



import org.bouncycastle.openpgp.PGPException;
import org.bouncycastle.openpgp.PGPPublicKeyRing;
import org.bouncycastle.openpgp.PGPPublicKeyRingCollection;
import org.bouncycastle.openpgp.PGPSecretKeyRingCollection;
import org.pgpainless.key.OpenPgpV4Fingerprint;
import org.pgpainless.key.protection.SecretKeyRingProtector;

import java.io.IOException;
import java.io.InputStream;
import java.util.Set;

public interface DecryptionBuilderInterface {

    DecryptWith onInputStream(InputStream inputStream);

    interface DecryptWith {

        VerifyWith decryptWith( SecretKeyRingProtector decryptor,  PGPSecretKeyRingCollection secretKeyRings);

        VerifyWith doNotDecrypt();

    }

    interface VerifyWith {

        HandleMissingPublicKeys verifyWith( PGPPublicKeyRingCollection publicKeyRings);

        HandleMissingPublicKeys verifyWith( Set<OpenPgpV4Fingerprint> trustedFingerprints,  PGPPublicKeyRingCollection publicKeyRings);

        HandleMissingPublicKeys verifyWith( Set<PGPPublicKeyRing> publicKeyRings);

        Build doNotVerify();

    }

    interface HandleMissingPublicKeys {

        Build handleMissingPublicKeysWith( MissingPublicKeyCallback callback);

        Build ignoreMissingPublicKeys();
    }

    interface Build {

        DecryptionStream build() throws IOException, PGPException;

    }

}
