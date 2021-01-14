Return-Path: <SRS0=QaZu=GR=lists.openwall.com=kernel-hardening-return-20644-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92817C433E0
	for <kernel-hardening@archiver.kernel.org>; Thu, 14 Jan 2021 03:23:36 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C04D2236F9
	for <kernel-hardening@archiver.kernel.org>; Thu, 14 Jan 2021 03:23:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C04D2236F9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20644-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32683 invoked by uid 550); 14 Jan 2021 03:23:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32648 invoked from network); 14 Jan 2021 03:23:28 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FEfB7z2Pg3tEbsUuKrEZpLqRqQiSI7cwvfIpRmMaPsg=;
        b=ERDheW9rkL9QnlcBk+gjMEWNicKOrODmm03n00UhTyuOanz3yIf+tVQ2IhyWO8CwON
         GKpMHZiqMwxQyAHoTp5gWGJ9T/9Cv+QqTqzD/Q0j7l6WJ3FK2LOR2lYJleXMUi/HaPtq
         hAo0tLKKn2Q7t/UBKM4+ZCJT32+rgjpcSTro39e8R9WGksf2PWbqS4pLDiAzVnHdQwFS
         cKqbNI76NaFU69m3LsyPmjdP3CzRq2oPRT9ho+fOAmBKu1eGIxoQiB5laGLfmKCFbLTh
         A+1wPcGioLznXyUUcakh1ovdoJ4a55uHhp/zcRprrvdM7164eLO9rwAW7zpziuw26kme
         wiUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FEfB7z2Pg3tEbsUuKrEZpLqRqQiSI7cwvfIpRmMaPsg=;
        b=rGg7vsWKMztYkU2uipNh8CE+t1/0Z5SncOsWqwmxkFIRcrsZw1VjR9UuLdLUAJBOl+
         CfoEEpD/uyvV7CxwNAQIBrGCuY0CHUJLfO93vhRgM51uMCiyCkXhoZDY8THch6A7EmtJ
         oL/Ru46tPxgU/ZsAcaFJe4eet3xsRWXY5qtR7lBeE2TJbfuqMYgvcvvzM4kWRH1AaDlh
         d92vPA2Y9F9jLIjsUD1UlDFJihZlXSHjFmA1VcNZcAjA9KcTcph5DT0iTmWDkMlS6dAG
         6G2+AXDvZhNzeBTBO4UqHImRjwKBTJE7Z9vL4BoLRRw0GyOcl9xw6BRMtB8wVZWeQp15
         CEEg==
X-Gm-Message-State: AOAM532rdUrhDgYlMD1Wmv+Ci3e2p8mXniQ56UaHqy8X2SDZlDfxEbOr
	fwjnb7xeFPb/draadaWIWbRDlVzo2VvjIzE2OIJW9Q==
X-Google-Smtp-Source: ABdhPJzfRhrd1kMrfF3j3pfT5UxcaTNs6jz7zJ40MKXw+hJC73ejwL+h4IUubxMUXNGPVLdYIr3TdisY3PE9ZGevcmg=
X-Received: by 2002:a2e:593:: with SMTP id 141mr2267937ljf.86.1610594596352;
 Wed, 13 Jan 2021 19:23:16 -0800 (PST)
MIME-Version: 1.0
References: <20201209192839.1396820-1-mic@digikod.net>
In-Reply-To: <20201209192839.1396820-1-mic@digikod.net>
From: Jann Horn <jannh@google.com>
Date: Thu, 14 Jan 2021 04:22:50 +0100
Message-ID: <CAG48ez3DE8xgr_etVGV5eNjH2CXXo9MR7jTcu+_LCkJUchLXcQ@mail.gmail.com>
Subject: Re: [PATCH v26 00/12] Landlock LSM
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: James Morris <jmorris@namei.org>, "Serge E . Hallyn" <serge@hallyn.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@amacapital.net>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Arnd Bergmann <arnd@arndb.de>, 
	Casey Schaufler <casey@schaufler-ca.com>, Jeff Dike <jdike@addtoit.com>, 
	Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, 
	Michael Kerrisk <mtk.manpages@gmail.com>, Richard Weinberger <richard@nod.at>, Shuah Khan <shuah@kernel.org>, 
	Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	kernel list <linux-kernel@vger.kernel.org>, 
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, 
	linux-security-module <linux-security-module@vger.kernel.org>, 
	"the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 9, 2020 at 8:28 PM Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> w=
rote:
> This patch series adds new built-time checks, a new test, renames some
> variables and functions to improve readability, and shift syscall
> numbers to align with -next.

Sorry, I've finally gotten around to looking at v26 - I hadn't
actually looked at v25 either yet. I think there's still one remaining
small issue in the filesystem access logic, but I think that's very
simple to fix, as long as we agree on what the expected semantics are.
Otherwise it basically looks good, apart from some typos.

I think v27 will be the final version of this series. :) (And I'll try
to actually look at that version much faster - I realize that waiting
for code reviews this long sucks.)
