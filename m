Return-Path: <SRS0=A0K3=KR=lists.openwall.com=kernel-hardening-return-21270-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17C5EC2B9F2
	for <kernel-hardening@archiver.kernel.org>; Sat, 22 May 2021 06:45:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4D91661244
	for <kernel-hardening@archiver.kernel.org>; Sat, 22 May 2021 06:45:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4D91661244
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21270-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17693 invoked by uid 550); 22 May 2021 06:45:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17661 invoked from network); 22 May 2021 06:45:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1621665887;
	bh=VAC/sk0xnp5/8Dxu21k60Pq40+L7HSTTvV7xE1S71qk=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kxLjaGcf/HX23OftpEm+6sritLglo0AJ45GakM1jc1YboXyCPIE1zu2pBrBBoE5NT
	 1fqsiJO7EyU12F51Xv/D9sskzu26JWVAA9tWdgotTu26ImpzXgRKwLCop5d8MfRtCJ
	 Y811fxZ7pPkEgrwMdW+Mbz/14xgqSjDdJpbqxS8g=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Date: Sat, 22 May 2021 08:44:42 +0200
From: John Wood <john.wood@gmx.com>
To: Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>,
	Jonathan Corbet <corbet@lwn.net>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>
Cc: John Wood <john.wood@gmx.com>, Andi Kleen <ak@linux.intel.com>,
	valdis.kletnieks@vt.edu,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: [PATCH v7 7/7] MAINTAINERS: Add a new entry for the Brute LSM
Message-ID: <20210522064442.GC3094@ubuntu>
References: <20210521172414.69456-1-john.wood@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210521172414.69456-1-john.wood@gmx.com>
X-Provags-ID: V03:K1:EaW59w+taFdVkQq3IT0Sp5BLroZB2cj3eMLYXxy5NmqL+Du6Lr5
 6xRDEefEotMQ+jKUXkh9C8PDTCFycM9VbtpMNWx+Y8QLFTqh/ZJxJHoLi7fmxSynxmsUFUz
 U2r5cjPhEsbNU3BBT1GbxkVQrplQ507I/eJS0e/VEmxEI3Ebz0+q9+XhdYefGrTy0g8cRqb
 /lxZtdJNXzBAYnDEaMuAQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:K2xzrztLlUg=:SBYCa464E05P8CoolV05rm
 8Z2ezmGEBvuhJMCbP3aBr6cxqcW24SVY3SrHLHeNd1Q5fC8aIXobpIPyObN1KU/ktvwPdktXq
 iQYkH7TuTBiCC7A0whAvncUWF3v0LqV05ZY+5NG/Osi2n8LAz+TeVoFwHq9dmbFOfST0O7s7e
 CuSIq/e3NfpJ4gF7Gu8cqLH0khzq0gJrqgAcd+bWkTWpI2sWTTQs47Y7NmMLbNdME7GHyyR9G
 Le1edo0tflCFSsED9K46WOLZVWRsI74/rofb6gkylK+EYeYRsUkprRnWyP2FEVwWlD07ngO6L
 rqUQYoCx9J5JY6taF/9kN8Lvh5IrdmtAD+yyZqeHFKHWRC+7zttQ67mYyImVYV2vZGdxRV8sj
 bDnHZNVjlhqkF3m16kz5KsMiHTUpmCBDVMOhdo0Bt+dB5xz0/aqwgnrXCQBQJ/AZGm5j3Zwl6
 9kLs1E/g217N8gNquDP4r9olHDXnMpE4inalw1r6skqQQFQ+NLPMWI0gfigZ7nOAd8aZl0253
 n2Vp4czU+Vy5ivpKegDqXu41WqWLzksURF7wmewbVY0mwJlOZytlS6nXSGwDp97yOYW9YPYJ3
 8uumpuAwf8sifNRrVvh6urC5dejg40Vl9Hdmg238yJ6VByT/j4eO1rvQq/pU4T+B/47OhXZ8n
 TT+G8QXVz/o6/UR7ugbTs4KAy1stOEyKBKf7oQmslajuA4lNgUzjVoSREb0FBmXtQGK4JvX84
 xYUrR0Fm2zEMRftgYnAToF0EjO4qOEUSeiNFMeamiCPuJoXRXw6vf79M1iW288zmn+lR2ACTy
 ZvuCWTCMU/ztR2OqQ+xY0S39ZDUp03FoDmr3JbUXywwb/TBVgqPreIHh/z6OG13ALuc6HiUd7
 Q1yrT/d6G4fYZ3O0/3Wog/bTEXLPXLubviY3+LMVDpGtBaY6TxyEE4bf4YJkHbNdn2Pb9Q2s3
 8DsCwU7hNZ8P0NBDWWNDXGz3NbEvF8JQNXM/oD2WpQaRakLNc6fZQfSXvIpP3YrzZ9eolifbL
 ddvSRUJhUXN0RnMcYU/FtnYRSE7NIglWujtGi3Usbv0DH9MRpecxwAR+5FRvC8nnwtMr1Qhut
 e6Djays4Mgl/qDBsPX/CXwQfWpiwyr6WhNO
Content-Transfer-Encoding: quoted-printable

In order to maintain the code for the Brute LSM add a new entry to the
maintainers list.

Signed-off-by: John Wood <john.wood@gmx.com>
=2D--
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 008fcad7ac00..102eb3d7dcd6 100644
=2D-- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3847,6 +3847,13 @@ L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/ethernet/brocade/bna/

+BRUTE SECURITY MODULE
+M:	John Wood <john.wood@gmx.com>
+S:	Maintained
+F:	Documentation/admin-guide/LSM/Brute.rst
+F:	security/brute/
+F:	tools/testing/selftests/brute/
+
 BSG (block layer generic sg v4 driver)
 M:	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
 L:	linux-scsi@vger.kernel.org
=2D-
2.25.1

