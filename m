Return-Path: <SRS0=VTO+=62=lists.openwall.com=kernel-hardening-return-18766-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61D44C54E8B
	for <kernel-hardening@archiver.kernel.org>; Tue, 12 May 2020 13:17:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B2FED206F5
	for <kernel-hardening@archiver.kernel.org>; Tue, 12 May 2020 13:17:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VGkzy6jY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B2FED206F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18766-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17791 invoked by uid 550); 12 May 2020 13:17:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17771 invoked from network); 12 May 2020 13:17:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1589289434;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AfyFJp14Em5eun2MnpR0ECXxjVn+ZY1Q40CAO8H54Xk=;
	b=VGkzy6jY8pEgBY0Y+LKs5hrMGVOh6EhRloJphCTNZ8QSamOmgbNwCCLL/AwK3H79QGRafP
	4hMXQM0DrchQYDjoQ55kYuSxdMEvX6cEZmApgmGX0HpiRLRsPKIg3ACDnOdIgHLynBETvW
	iQgQvmriokh2+7elAfvoePmPewUv+Xs=
X-MC-Unique: JyLrBjopMn2UUB8-ic6Ftw-1
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20200511215101.302530-1-Jason@zx2c4.com>
References: <20200511215101.302530-1-Jason@zx2c4.com> <CAHmME9oXiTmVuOYmG=K3ijWK+zP2yB9a2CFjbLx_5fkDiH30Tg@mail.gmail.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: dhowells@redhat.com, keyrings@vger.kernel.org,
    linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
    Greg KH <gregkh@linuxfoundation.org>,
    Linus Torvalds <torvalds@linux-foundation.org>,
    kernel-hardening@lists.openwall.com,
    Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH v3] security/keys: rewrite big_key crypto to use library interface
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2620779.1589289425.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Tue, 12 May 2020 14:17:05 +0100
Message-ID: <2620780.1589289425@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12

Jason A. Donenfeld <Jason@zx2c4.com> wrote:

> -	/* no ->update(); don't add it without changing big_key_crypt() nonce =
*/
> +	/* no ->update(); don't add it without changing chacha20poly1305's non=
ce

Note that ->update() doesn't have to modify the contents of the key, but c=
an
just rather replace them entirely.  See attached.  The actual work is done=
 in
big_key_preparse(); all big_key_update() has to do is apply it and dispose=
 of
the old payload.

David
---
commit 724e76c185d517f35ead4f72f9958850c9218f4d
Author: David Howells <dhowells@redhat.com>
Date:   Tue May 12 14:03:53 2020 +0100

    keys: Implement update for the big_key type
    =

    Implement the ->update op for the big_key type.
    =

    Signed-off-by: David Howells <dhowells@redhat.com>

diff --git a/include/keys/big_key-type.h b/include/keys/big_key-type.h
index 3fee04f81439..988d90d77f53 100644
--- a/include/keys/big_key-type.h
+++ b/include/keys/big_key-type.h
@@ -18,5 +18,6 @@ extern void big_key_revoke(struct key *key);
 extern void big_key_destroy(struct key *key);
 extern void big_key_describe(const struct key *big_key, struct seq_file *=
m);
 extern long big_key_read(const struct key *key, char *buffer, size_t bufl=
en);
+extern int big_key_update(struct key *key, struct key_preparsed_payload *=
prep);
 =

 #endif /* _KEYS_BIG_KEY_TYPE_H */
diff --git a/security/keys/big_key.c b/security/keys/big_key.c
index d43f3daab2b8..dd708e8f13c0 100644
--- a/security/keys/big_key.c
+++ b/security/keys/big_key.c
@@ -47,7 +47,7 @@ struct key_type key_type_big_key =3D {
 	.destroy		=3D big_key_destroy,
 	.describe		=3D big_key_describe,
 	.read			=3D big_key_read,
-	/* no ->update(); don't add it without changing chacha20poly1305's nonce=
 */
+	.update			=3D big_key_update,
 };
 =

 /*
@@ -191,6 +191,23 @@ void big_key_destroy(struct key *key)
 	key->payload.data[big_key_data] =3D NULL;
 }
 =

+/*
+ * Update a big key
+ */
+int big_key_update(struct key *key, struct key_preparsed_payload *prep)
+{
+	int ret;
+
+	ret =3D key_payload_reserve(key, prep->datalen);
+	if (ret < 0)
+		return ret;
+
+	if (key_is_positive(key))
+		big_key_destroy(key);
+
+	return generic_key_instantiate(key, prep);
+}
+
 /*
  * describe the big_key key
  */

