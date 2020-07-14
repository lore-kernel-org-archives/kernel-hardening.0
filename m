Return-Path: <SRS0=Qsi5=AZ=lists.openwall.com=kernel-hardening-return-19318-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D66BFC433E3
	for <kernel-hardening@archiver.kernel.org>; Tue, 14 Jul 2020 18:41:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2D041225AA
	for <kernel-hardening@archiver.kernel.org>; Tue, 14 Jul 2020 18:41:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="W1Yl3XUG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2D041225AA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19318-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32314 invoked by uid 550); 14 Jul 2020 18:41:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32294 invoked from network); 14 Jul 2020 18:41:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=SimmloHZQtBhOnb9Pbgsw72I1O5VIdL523t/ncOnsgk=; b=W1Yl3XUG9MzYNah9l9+4fRf5F9
	h49otnq+/660uWOaP2mI+uT0FEtijYl0Z857koqs/q/DNBdtGnEnRubTJQU9UgUwlXeirrE5ICls4
	DWrWjQzBhwo4RR3cM1LZCT32KQQ+TSv84fz0enXVKcFX7mD/5DI07ID3Gi1BeY4O8NSMW5T9hgsUh
	KWey6VEaUzKEgOu0f6LrbD4+qQ/Mw0Wgyca6+KZCj9zJxv+Cy/YyUK8bfcv4QUcN1NScLN0PUpkBq
	t94ot1QTNg7Vknoh/C0CW2OlronpItPtycZ0sCKu8ruViFpHqOiyjMlOgsT2spFr1GtAw56/Llwu/
	tS4ScVZQ==;
Subject: Re: [PATCH v6 5/7] fs,doc: Enable to enforce noexec mounts or file
 exec through O_MAYEXEC
To: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>,
 linux-kernel@vger.kernel.org
Cc: Aleksa Sarai <cyphar@cyphar.com>, Alexei Starovoitov <ast@kernel.org>,
 Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton
 <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>,
 Christian Brauner <christian.brauner@ubuntu.com>,
 Christian Heimes <christian@python.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Deven Bowers <deven.desai@linux.microsoft.com>,
 Dmitry Vyukov <dvyukov@google.com>, Eric Biggers <ebiggers@kernel.org>,
 Eric Chiang <ericchiang@google.com>, Florian Weimer <fweimer@redhat.com>,
 James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>,
 Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
 Kees Cook <keescook@chromium.org>,
 Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
 Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>,
 Michael Kerrisk <mtk.manpages@gmail.com>,
 =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>,
 Mimi Zohar <zohar@linux.ibm.com>,
 =?UTF-8?Q?Philippe_Tr=c3=a9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
 Scott Shell <scottsh@microsoft.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Shuah Khan <shuah@kernel.org>, Steve Dower <steve.dower@python.org>,
 Steve Grubb <sgrubb@redhat.com>,
 Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
 Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
 Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
 kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20200714181638.45751-1-mic@digikod.net>
 <20200714181638.45751-6-mic@digikod.net>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <038639b1-92da-13c1-b3e5-8f13639a815e@infradead.org>
Date: Tue, 14 Jul 2020 11:40:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200714181638.45751-6-mic@digikod.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit

Hi,

On 7/14/20 11:16 AM, Mickaël Salaün wrote:

> ---
>  Documentation/admin-guide/sysctl/fs.rst | 45 +++++++++++++++++++++++++
>  fs/namei.c                              | 29 +++++++++++++---
>  include/linux/fs.h                      |  1 +
>  kernel/sysctl.c                         | 12 +++++--
>  4 files changed, 80 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/admin-guide/sysctl/fs.rst b/Documentation/admin-guide/sysctl/fs.rst
> index 2a45119e3331..02ec384b8bbf 100644
> --- a/Documentation/admin-guide/sysctl/fs.rst
> +++ b/Documentation/admin-guide/sysctl/fs.rst

Reviewed-by: Randy Dunlap <rdunlap@infradead.org>

with one tiny nit:

> @@ -165,6 +166,50 @@ system needs to prune the inode list instead of allocating
> +The ability to restrict code execution must be thought as a system-wide policy,
> +which first starts by restricting mount points with the ``noexec`` option.
> +This option is also automatically applied to special filesystems such as /proc
> +.  This prevents files on such mount points to be directly executed by the

Can you move that period from the beginning of the line to the end of the
previous line?

> +kernel or mapped as executable memory (e.g. libraries).  With script
> +interpreters using the ``O_MAYEXEC`` flag, the executable permission can then
> +be checked before reading commands from files. This makes it possible to
> +enforce the ``noexec`` at the interpreter level, and thus propagates this
> +security policy to scripts.  To be fully effective, these interpreters also
> +need to handle the other ways to execute code: command line parameters (e.g.,
> +option ``-e`` for Perl), module loading (e.g., option ``-m`` for Python),
> +stdin, file sourcing, environment variables, configuration files, etc.
> +According to the threat model, it may be acceptable to allow some script
> +interpreters (e.g. Bash) to interpret commands from stdin, may it be a TTY or a
> +pipe, because it may not be enough to (directly) perform syscalls.

thanks.
-- 
~Randy

