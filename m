Return-Path: <SRS0=yLFo=65=lists.openwall.com=kernel-hardening-return-18817-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B23AC433E0
	for <kernel-hardening@archiver.kernel.org>; Fri, 15 May 2020 14:44:21 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 918F020671
	for <kernel-hardening@archiver.kernel.org>; Fri, 15 May 2020 14:44:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RdHJ14yy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 918F020671
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18817-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24448 invoked by uid 550); 15 May 2020 14:44:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24408 invoked from network); 15 May 2020 14:44:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1589553837;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hR6lCjnUOV2j2gabpoQGpgvPB5RUTChOvM8hrmj3dmQ=;
	b=RdHJ14yymja0gFB88CoZ2hagTm4vSMsUZOuUMPqDpFZO9XFwM3NilOVK4jOd+jUzDWURpj
	mLY73Gp9SQ+/5bYr7LwCT0UFeANcfkegKygguGM6PNPsh++dOsZNkXziRVUwt8O19DrNCo
	shDQ4qXjEQvmGGR7MwqCD1XTwjZyLtA=
X-MC-Unique: IBhV3vZSOp6wkLbJJ_diLA-1
From: Florian Weimer <fweimer@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>,  Al Viro
 <viro@zeniv.linux.org.uk>,
  Aleksa Sarai <cyphar@cyphar.com>,  Andy Lutomirski <luto@kernel.org>,
  Mimi Zohar <zohar@linux.ibm.com>,  Stephen Smalley
 <stephen.smalley.work@gmail.com>,  Christian Heimes
 <christian@python.org>,  Deven Bowers <deven.desai@linux.microsoft.com>,
  Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,  John Johansen
 <john.johansen@canonical.com>,  Kentaro Takeda <takedakn@nttdata.co.jp>,
  "Lev R. Oshvang ." <levonshe@gmail.com>,  Alexei Starovoitov
 <ast@kernel.org>,  Daniel Borkmann <daniel@iogearbox.net>,  Eric Chiang
 <ericchiang@google.com>,  James Morris <jmorris@namei.org>,  Jan Kara
 <jack@suse.cz>,  Jann Horn <jannh@google.com>,  Jonathan Corbet
 <corbet@lwn.net>,  Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
  Matthew Garrett <mjg59@google.com>,  Matthew Wilcox
 <willy@infradead.org>,  Michael Kerrisk <mtk.manpages@gmail.com>,
  =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>,
  Philippe =?utf-8?Q?Tr=C3=A9buchet?=
 <philippe.trebuchet@ssi.gouv.fr>,  Scott Shell <scottsh@microsoft.com>,
  Sean Christopherson <sean.j.christopherson@intel.com>,  Shuah Khan
 <shuah@kernel.org>,  Steve Dower <steve.dower@python.org>,  Steve Grubb
 <sgrubb@redhat.com>,  Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
  Vincent Strubel <vincent.strubel@ssi.gouv.fr>,  linux-kernel
 <linux-kernel@vger.kernel.org>,  kernel-hardening@lists.openwall.com,
  linux-api@vger.kernel.org,  linux-integrity@vger.kernel.org,  LSM List
 <linux-security-module@vger.kernel.org>,  Linux FS Devel
 <linux-fsdevel@vger.kernel.org>
Subject: Re: How about just O_EXEC? (was Re: [PATCH v5 3/6] fs: Enable to enforce noexec mounts or file exec through O_MAYEXEC)
References: <20200505153156.925111-4-mic@digikod.net>
	<CAEjxPJ7y2G5hW0WTH0rSrDZrorzcJ7nrQBjfps2OWV5t1BUYHw@mail.gmail.com>
	<202005131525.D08BFB3@keescook> <202005132002.91B8B63@keescook>
	<CAEjxPJ7WjeQAz3XSCtgpYiRtH+Jx-UkSTaEcnVyz_jwXKE3dkw@mail.gmail.com>
	<202005140830.2475344F86@keescook>
	<CAEjxPJ4R_juwvRbKiCg5OGuhAi1ZuVytK4fKCDT_kT6VKc8iRg@mail.gmail.com>
	<b740d658-a2da-5773-7a10-59a0ca52ac6b@digikod.net>
	<202005142343.D580850@keescook>
	<87a729wpu1.fsf@oldenburg2.str.redhat.com>
	<202005150732.17C5EE0@keescook>
Date: Fri, 15 May 2020 16:43:37 +0200
In-Reply-To: <202005150732.17C5EE0@keescook> (Kees Cook's message of "Fri, 15
	May 2020 07:37:16 -0700")
Message-ID: <87r1vluuli.fsf@oldenburg2.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16

* Kees Cook:

> On Fri, May 15, 2020 at 10:43:34AM +0200, Florian Weimer wrote:
>> * Kees Cook:
>> 
>> > Maybe I've missed some earlier discussion that ruled this out, but I
>> > couldn't find it: let's just add O_EXEC and be done with it. It actually
>> > makes the execve() path more like openat2() and is much cleaner after
>> > a little refactoring. Here are the results, though I haven't emailed it
>> > yet since I still want to do some more testing:
>> > https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/log/?h=kspp/o_exec/v1
>> 
>> I think POSIX specifies O_EXEC in such a way that it does not confer
>> read permissions.  This seems incompatible with what we are trying to
>> achieve here.
>
> I was trying to retain this behavior, since we already make this
> distinction between execve() and uselib() with the MAY_* flags:
>
> execve():
>         struct open_flags open_exec_flags = {
>                 .open_flag = O_LARGEFILE | O_RDONLY | __FMODE_EXEC,
>                 .acc_mode = MAY_EXEC,
>
> uselib():
>         static const struct open_flags uselib_flags = {
>                 .open_flag = O_LARGEFILE | O_RDONLY | __FMODE_EXEC,
>                 .acc_mode = MAY_READ | MAY_EXEC,
>
> I tried to retain this in my proposal, in the O_EXEC does not imply
> MAY_READ:

That doesn't quite parse for me, sorry.

The point is that the script interpreter actually needs to *read* those
files in order to execute them.

Thanks,
Florian

