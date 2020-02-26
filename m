Return-Path: <SRS0=AgXo=4O=lists.openwall.com=kernel-hardening-return-17964-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C672C4BA24
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 20:30:03 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B9C4A2072D
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 20:30:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uVGxei6e"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B9C4A2072D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17964-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10189 invoked by uid 550); 26 Feb 2020 20:29:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10157 invoked from network); 26 Feb 2020 20:29:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UBBYCrKEWuOTMe5EyAwkmAIoT9VVH7fpRYrxe98vHCY=;
        b=uVGxei6e9yF0ykQTCRbpF1Xcix7hidQzKjxKmA1TAaLMeWBjYprbRURWAhfm37DnMO
         ALgX0i/omp1eS4k0RzspH50ykrH6+tYuInb+/v3+dsQydB2Gf1JHLwkVAh7PVr7+/vRd
         FEXucDxG2gKpfW36N9FsDf3SO19ksbFgC8vKl0aQmSTLblf+uGgXkO2fWfA4XxFM+8Js
         jMnrrdCbNQqqzS+mSb6pWZJeJ7i2esnsfJ3vaxuZQhlQ6v6KWz6UIlXWOgBKqvTBvuUx
         ppCNzmE84DNL1pPvauf2ZbbPd7pYXUAe4jXhVazh2kQtXxxw/ibvY1NOsCYPKL926wLL
         APqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UBBYCrKEWuOTMe5EyAwkmAIoT9VVH7fpRYrxe98vHCY=;
        b=lWySZUscpQsU7iTWcmOzoU9u0ryku7gsu28aJQPbQKZlOcGpPCIr4ByI+c6ArrTlrg
         +5rxguGrulZvJwlKf1TGbRSQezSASPskSlZWEgbS62WgVkpENqYb52byfvqKMbsfCzoH
         s/zhnzWVKj8zEELlJVWQYTHb8wkSFnIetpU9TfR/xUc28zE9ylqsqfeA3NDs9qUF6BUf
         +csylgjwvIoOu4BFVrz+AtL+aNeMUv4fqIGbYeDUVb1RHz8II9nlNxVVlBEHSUaQiukw
         dUA7x0fW1XGVX3hy7UAYUIX4vksEoo5HAICkokR0+Ohz8TU4Tm0Rdg0mODaCq1nb7YnH
         FD2g==
X-Gm-Message-State: APjAAAWgcnefmh8eO71B2WdsBMpVALCF08Wk54SdkFtZ3FQRP7u2m8qR
	RfLc/+NDxnW1uRl5kj4Np5o77Z3P7uyVxZIqpxMKfQ==
X-Google-Smtp-Source: APXvYqy7E7A1017OqCy2OgReSsVvINF1u2X33Ne5TrenikJqc56r0qDxjZlM9E+pAKGCyqxj9LTAbiG86jPOqxjX13k=
X-Received: by 2002:a05:6830:1219:: with SMTP id r25mr502917otp.180.1582748984487;
 Wed, 26 Feb 2020 12:29:44 -0800 (PST)
MIME-Version: 1.0
References: <20200224160215.4136-1-mic@digikod.net> <20200224160215.4136-6-mic@digikod.net>
In-Reply-To: <20200224160215.4136-6-mic@digikod.net>
From: Jann Horn <jannh@google.com>
Date: Wed, 26 Feb 2020 21:29:18 +0100
Message-ID: <CAG48ez36SMrPPgsj0omcVukRLwOzBzqWOQjuGCmmmrmsGiNukw@mail.gmail.com>
Subject: Re: [RFC PATCH v14 05/10] fs,landlock: Support filesystem access-control
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: kernel list <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Andy Lutomirski <luto@amacapital.net>, Arnd Bergmann <arnd@arndb.de>, 
	Casey Schaufler <casey@schaufler-ca.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>, Jonathan Corbet <corbet@lwn.net>, 
	Kees Cook <keescook@chromium.org>, Michael Kerrisk <mtk.manpages@gmail.com>, 
	=?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mickael.salaun@ssi.gouv.fr>, 
	"Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, 
	Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, 
	linux-arch <linux-arch@vger.kernel.org>, linux-doc@vger.kernel.org, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, 
	linux-security-module <linux-security-module@vger.kernel.org>, 
	"the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 24, 2020 at 5:03 PM Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> =
wrote:
> +static inline u32 get_mem_access(unsigned long prot, bool private)
> +{
> +       u32 access =3D LANDLOCK_ACCESS_FS_MAP;
> +
> +       /* Private mapping do not write to files. */
> +       if (!private && (prot & PROT_WRITE))
> +               access |=3D LANDLOCK_ACCESS_FS_WRITE;
> +       if (prot & PROT_READ)
> +               access |=3D LANDLOCK_ACCESS_FS_READ;
> +       if (prot & PROT_EXEC)
> +               access |=3D LANDLOCK_ACCESS_FS_EXECUTE;
> +       return access;
> +}

When I do the following, is landlock going to detect that the mmap()
is a read access, or is it incorrectly going to think that it's
neither read nor write?

$ cat write-only.c
#include <fcntl.h>
#include <sys/mman.h>
#include <stdio.h>
int main(void) {
  int fd =3D open("/etc/passwd", O_RDONLY);
  char *ptr =3D mmap(NULL, 0x1000, PROT_WRITE, MAP_PRIVATE, fd, 0);
  printf("'%.*s'\n", 4, ptr);
}
$ gcc -o write-only write-only.c -Wall
$ ./write-only
'root'
$
