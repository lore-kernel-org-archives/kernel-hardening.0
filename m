Return-Path: <SRS0=0wzs=6O=lists.openwall.com=kernel-hardening-return-18682-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98FB4C83001
	for <kernel-hardening@archiver.kernel.org>; Thu, 30 Apr 2020 08:08:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id F3C7D2073E
	for <kernel-hardening@archiver.kernel.org>; Thu, 30 Apr 2020 08:08:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F3C7D2073E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ubuntu.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18682-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11443 invoked by uid 550); 30 Apr 2020 08:08:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11416 invoked from network); 30 Apr 2020 08:08:41 -0000
Date: Thu, 30 Apr 2020 10:07:46 +0200
From: Christian Brauner <christian.brauner@ubuntu.com>
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>,
	linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@kernel.org>,
	Christian Heimes <christian@python.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Deven Bowers <deven.desai@linux.microsoft.com>,
	Eric Chiang <ericchiang@google.com>,
	Florian Weimer <fweimer@redhat.com>,
	James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>,
	Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
	Kees Cook <keescook@chromium.org>,
	Matthew Garrett <mjg59@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Philippe =?utf-8?Q?Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
	Scott Shell <scottsh@microsoft.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Shuah Khan <shuah@kernel.org>, Steve Dower <steve.dower@python.org>,
	Steve Grubb <sgrubb@redhat.com>,
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 0/5] Add support for RESOLVE_MAYEXEC
Message-ID: <20200430080746.n26fja2444w6i2db@wittgenstein>
References: <20200428175129.634352-1-mic@digikod.net>
 <20200430015429.wuob7m5ofdewubui@yavin.dot.cyphar.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200430015429.wuob7m5ofdewubui@yavin.dot.cyphar.com>

On Thu, Apr 30, 2020 at 11:54:29AM +1000, Aleksa Sarai wrote:
> On 2020-04-28, Mickaël Salaün <mic@digikod.net> wrote:
> > The goal of this patch series is to enable to control script execution
> > with interpreters help.  A new RESOLVE_MAYEXEC flag, usable through
> > openat2(2), is added to enable userspace script interpreter to delegate
> > to the kernel (and thus the system security policy) the permission to
> > interpret/execute scripts or other files containing what can be seen as
> > commands.
> > 
> > This third patch series mainly differ from the previous one by relying
> > on the new openat2(2) system call to get rid of the undefined behavior
> > of the open(2) flags.  Thus, the previous O_MAYEXEC flag is now replaced
> > with the new RESOLVE_MAYEXEC flag and benefits from the openat2(2)
> > strict check of this kind of flags.
> 
> My only strong upfront objection is with this being a RESOLVE_ flag.
> 
> RESOLVE_ flags have a specific meaning (they generally apply to all
> components, and affect the rules of path resolution). RESOLVE_MAYEXEC
> does neither of these things and so seems out of place among the other
> RESOLVE_ flags.
> 
> I would argue this should be an O_ flag, but not supported for the

I agree.

Christian
