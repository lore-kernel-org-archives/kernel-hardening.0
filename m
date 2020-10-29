Return-Path: <SRS0=+vCX=EE=lists.openwall.com=kernel-hardening-return-20297-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4BD0C388F7
	for <kernel-hardening@archiver.kernel.org>; Thu, 29 Oct 2020 01:06:53 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DED9C2071A
	for <kernel-hardening@archiver.kernel.org>; Thu, 29 Oct 2020 01:06:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OQFoy5zJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DED9C2071A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20297-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32703 invoked by uid 550); 29 Oct 2020 01:06:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32621 invoked from network); 29 Oct 2020 01:06:38 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sdW8glxlqT52o6OrX86F7zpNSSHvHFcM+yTkw93QmvU=;
        b=OQFoy5zJcvGaPYRjULm9FRQ4mPpGgZUmLkSBusyWrqN7wYA6OKMhtdFCj7k6mxGVVn
         /OB6g0MYcj16bI3y0RZAnTaIqfzbpgMOw5XGd4GR3BPNbqmLRVZfrNgeih5y59Ukq7m8
         hQ2JsWLBe5/8kwUHrYWzO15rATBwrSZSug26Qn738s0cmusMvscNdYWrEyDFeIIxigX/
         djhhUiRssu5Q15Vhx6qIjm2Ox/u4rrcbzo4r3H7eYiBYzRqiKzLmUsoc0+Jsbge3+k21
         5yjSQlazLmxu+Kte6xds9kyAl4e/NpD7HFcpW0zVmKkL0FHCl8jErMGvQv9yJe4Z5ez9
         yF+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sdW8glxlqT52o6OrX86F7zpNSSHvHFcM+yTkw93QmvU=;
        b=chta7Pr/ufbGzOKTBCR2/DULzBTFIBlY4pSgpN3stycwtexzCZlJS8htXbz/LcFSX1
         uUQhXSndxQgdHE7DUOaEjTMDYbFJvgJXJIL83Axb0h/vuC8AIclv3KFrhxcHaI+PbYAn
         IMoG+xCplllSbEDcR3s9yNG/KPAvb8EyyCqz0dUG0B1jT2pUPMObpqBfq2K7Plhral4i
         c1Psk7KCofrv3WKsUvufJwMtcpgJb9XBBoGPfHxzt+0P7/i4MFIbI0b/GM6oW3thNIpD
         ka/mzfNvDP1+7Ot6F9U00AwNwFZxLIx3MkC2xsl3+1KMH6fLCJ4t3fKd13GqJfCZmjS4
         JgVQ==
X-Gm-Message-State: AOAM531sOhb0vcGkhBVa1wDurd1b5kzR33adDLpugJK67STfAczoksqz
	ilpvHr673hWJivg+psB6BCqrwM6k/X8wedeqM3Flqw==
X-Google-Smtp-Source: ABdhPJzyyZaaLe2JA3VvgL7cUtSj9LlNwA65qJkm7Fv1qbvcq5QSy/4U16ih92Ck7/3Dyb1x1IAYXE/2zulh7bsAAQY=
X-Received: by 2002:a2e:b888:: with SMTP id r8mr712081ljp.138.1603933586611;
 Wed, 28 Oct 2020 18:06:26 -0700 (PDT)
MIME-Version: 1.0
References: <20201027200358.557003-1-mic@digikod.net> <20201027200358.557003-4-mic@digikod.net>
In-Reply-To: <20201027200358.557003-4-mic@digikod.net>
From: Jann Horn <jannh@google.com>
Date: Thu, 29 Oct 2020 02:06:00 +0100
Message-ID: <CAG48ez2idPLmoQmqi5SL-kL1B=3W4LBAEc8r7oUp2J9SxTr1rA@mail.gmail.com>
Subject: Re: [PATCH v22 03/12] landlock: Set up the security framework and
 manage credentials
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
	"the arch/x86 maintainers" <x86@kernel.org>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 27, 2020 at 9:04 PM Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> =
wrote:
> Process's credentials point to a Landlock domain, which is underneath
> implemented with a ruleset.  In the following commits, this domain is
> used to check and enforce the ptrace and filesystem security policies.
> A domain is inherited from a parent to its child the same way a thread
> inherits a seccomp policy.
>
> Cc: James Morris <jmorris@namei.org>
> Cc: Jann Horn <jannh@google.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Serge E. Hallyn <serge@hallyn.com>
> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@linux.microsoft.com>

Reviewed-by: Jann Horn <jannh@google.com>
