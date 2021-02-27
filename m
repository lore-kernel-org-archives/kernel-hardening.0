Return-Path: <SRS0=SuJ0=H5=lists.openwall.com=kernel-hardening-return-20857-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28242C433DB
	for <kernel-hardening@archiver.kernel.org>; Sat, 27 Feb 2021 18:24:57 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 295D464E28
	for <kernel-hardening@archiver.kernel.org>; Sat, 27 Feb 2021 18:24:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 295D464E28
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20857-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3133 invoked by uid 550); 27 Feb 2021 18:24:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3098 invoked from network); 27 Feb 2021 18:24:48 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1614450262;
	bh=fQX81Of9P558A+iW5ccipb7QmmQldM7xCcBpY9SL5ME=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KKo7uOJsK7eiTUNlSwtDhA8nXmroKrtcBsFUjzsjtAS6HVgVhM5YAqg3w/mO8VUtg
	 6jcLSfNxS6HXZu/HXYAHR7j00GFMsKvqQQI9go5Iz+sFP9EUB3PA4fjMTCsBG9RXbd
	 OKJtw8klsE6O7KPXKNJalHQK3lexYG3vWd1GJuJ4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
From: John Wood <john.wood@gmx.com>
To: Kees Cook <keescook@chromium.org>,
	Jann Horn <jannh@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	James Morris <jmorris@namei.org>,
	Shuah Khan <shuah@kernel.org>
Cc: John Wood <john.wood@gmx.com>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: [PATCH v5 8/8] MAINTAINERS: Add a new entry for the Brute LSM
Date: Sat, 27 Feb 2021 16:30:13 +0100
Message-Id: <20210227153013.6747-9-john.wood@gmx.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210227153013.6747-1-john.wood@gmx.com>
References: <20210227153013.6747-1-john.wood@gmx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:YCBa3C72qUpbebnlxKQ4mu4vQ7rKJucUJNIwapSKKCC7ldfCL4/
 cHNiaiBusOPr4u1aJQGCqC266giyRB/Fous/c1Fu0jIbyXUCvvMwVlKlimn3b04cOa+bnLl
 ebL9/3tILqgdpdmUI0PuAPvpbbHiSPckTu75V2d25+4/djaduFCn+RfgW2rofmHM72bL2/l
 XVWnVoWkkKzA/una/bTcQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:LSgZdMC8U7o=:NWQk9JU1Xuh50D051Cw+Zb
 gtV46vSdssnFV+mbLtOmfTSzEcxs7Iov6rRgGed1ZqcPvutCt4Qkr3F+81ReoV6PPQGKJYcMQ
 qswNC0+/YoZtfbK1pLeb19XWHz9WeHAJAIcMm3Y/r8W5fevTq4QMp1I0X0PtZzPPMfTKzX+rf
 /3lxJ7bq93v9MG5fx+/4DrwwwfY1UZ22YeSnvMaTyksPKgJ3DN0zKlLmP2LudUtc3mV/t2EQi
 aOz1pKqUlyoKybkmx29Cgm9FGYghJJQPO+tk2R17tV/s/uhS0QIwGJ+W9AFihSaH/qfXCargQ
 rLnMyfHUX/xsKM6YxzwxfseuTp9MoXfM6acj4A7xonazBBIwaYm6rIzzpnDkVA0zT3u1mFGcJ
 PPDGjNM7KhEPvPB7vvauhw6u7MseXOK1ZJl+H14JTqVJQirsxI5aUksG9U7nQForV01Xqis1B
 IAsj+cpBL9BAQahirB/HPyDxdQn8OtpoD4qiKa064FnCwS06W1eQQXKNuShpnFdz24i3O6HDY
 WbsBguOcLrU6NmI/njcIsaOcXEz4lcKVaWyhZv9WoEzX0RrOkCK+YfUP4OJa0cC1B1JGFFMNi
 BPsx/i/lTYXSvmYqU7oyjPbQMCHneNfNZaC5m94BYSM+CZ9CyR/sUwOUSczfdilzuCUuzupcN
 XWOTAFNI/XKVEa/sNamkMywz99sEZ2n/f+9eLisJYtQ3hBLvYHY6HPsvwU6ll1QACq3esGshF
 xCdmjd4gS8Wtz8WPH22sz3ctJGK3r2LNQcbEWB6fMsf+sxsM/Adizsh4IGqlC4ypKmnlhHIj5
 6ab18EwceAHvWZhxNt84vbArFO3t6IslXgCo3+UYtlfPQqhJlut1lUQJmbxuX7oHlNgXkRgtR
 6fcWdZ7AcVhErcRr/Bhw==

In order to maintain the code for the Brute LSM add a new entry to the
maintainers list.

Signed-off-by: John Wood <john.wood@gmx.com>
=2D--
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index d92f85ca831d..0b88b7a99991 100644
=2D-- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3764,6 +3764,13 @@ L:	netdev@vger.kernel.org
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

