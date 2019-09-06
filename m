Return-Path: <SRS0=RXjH=XB=lists.openwall.com=kernel-hardening-return-16862-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48F02C43331
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Sep 2019 19:07:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 941902081B
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Sep 2019 19:07:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 941902081B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16862-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7296 invoked by uid 550); 6 Sep 2019 19:07:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7274 invoked from network); 6 Sep 2019 19:07:34 -0000
From: Steve Grubb <sgrubb@redhat.com>
To: Florian Weimer <fweimer@redhat.com>
Cc: =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>, linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>, Alexei Starovoitov <ast@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Christian Heimes <christian@python.org>, Daniel Borkmann <daniel@iogearbox.net>, Eric Chiang <ericchiang@google.com>, James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>, Michael Kerrisk <mtk.manpages@gmail.com>, =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mickael.salaun@ssi.gouv.fr>, Mimi Zohar <zohar@linux.ibm.com>, Philippe =?ISO-8859-1?Q?Tr=E9buchet?= <philippe.trebuchet@ssi.gouv.fr>, Scott Shell <scottsh@microsoft.com>, Sean Christopherson <sean.j.christopherson@intel.com>, Shuah Khan <shuah@kernel.org>, Song Liu <songliubraving@fb.com>, Steve Dower <steve.dower@python.org>, Thibaut S
 autereau <thibaut.sautereau@ssi.gouv.fr>, Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Yves-Alexis Perez <yves-alexis.perez@ssi.gouv.fr>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] Add support for O_MAYEXEC
Date: Fri, 06 Sep 2019 15:07:19 -0400
Message-ID: <1802966.yheqmZt8Si@x2>
Organization: Red Hat
In-Reply-To: <87mufhckxv.fsf@oldenburg2.str.redhat.com>
References: <20190906152455.22757-1-mic@digikod.net> <2989749.1YmIBkDdQn@x2> <87mufhckxv.fsf@oldenburg2.str.redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Fri, 06 Sep 2019 19:07:23 +0000 (UTC)

On Friday, September 6, 2019 2:57:00 PM EDT Florian Weimer wrote:
> * Steve Grubb:
> > Now with LD_AUDIT
> > $ LD_AUDIT=/home/sgrubb/test/openflags/strip-flags.so.0 strace ./test
> > 2>&1 | grep passwd openat(3, "passwd", O_RDONLY)           = 4
> > 
> > No O_CLOEXEC flag.
> 
> I think you need to explain in detail why you consider this a problem.

Because you can strip the O_MAYEXEC flag from being passed into the kernel. 
Once you do that, you defeat the security mechanism because it never gets 
invoked. The issue is that the only thing that knows _why_ something is being 
opened is user space. With this mechanism, you can attempt to pass this 
reason to the kernel so that it may see if policy permits this. But you can 
just remove the flag.

-Steve

> With LD_PRELOAD and LD_AUDIT, you can already do anything, including
> scanning other loaded objects for a system call instruction and jumping
> to that (in case a security module in the kernel performs a PC check to
> confer additional privileges).
> 
> Thanks,
> Florian




