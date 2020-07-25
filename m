Return-Path: <SRS0=3OVi=BE=lists.openwall.com=kernel-hardening-return-19449-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7588C433E0
	for <kernel-hardening@archiver.kernel.org>; Sat, 25 Jul 2020 11:19:34 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2CF28206C1
	for <kernel-hardening@archiver.kernel.org>; Sat, 25 Jul 2020 11:19:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2CF28206C1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ubuntu.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19449-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13552 invoked by uid 550); 25 Jul 2020 11:19:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13532 invoked from network); 25 Jul 2020 11:19:26 -0000
Date: Sat, 25 Jul 2020 13:15:58 +0200
From: Christian Brauner <christian.brauner@ubuntu.com>
To: Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>,
	Aleksa Sarai <cyphar@cyphar.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Andy Lutomirski <luto@kernel.org>,
	Christian Heimes <christian@python.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Deven Bowers <deven.desai@linux.microsoft.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Eric Chiang <ericchiang@google.com>,
	Florian Weimer <fweimer@redhat.com>,
	James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>,
	Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
	Matthew Garrett <mjg59@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Philippe =?utf-8?Q?Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
	Scott Shell <scottsh@microsoft.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Shuah Khan <shuah@kernel.org>, Steve Dower <steve.dower@python.org>,
	Steve Grubb <sgrubb@redhat.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Thibaut Sautereau <thibaut.sautereau@clip-os.org>,
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v7 0/7] Add support for O_MAYEXEC
Message-ID: <20200725111558.sawfxujpsxpzw6fk@wittgenstein>
References: <20200723171227.446711-1-mic@digikod.net>
 <202007241205.751EBE7@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202007241205.751EBE7@keescook>

On Fri, Jul 24, 2020 at 12:06:53PM -0700, Kees Cook wrote:
> I think this looks good now.
> 
> Andrew, since you're already carrying my exec clean-ups (repeated here
> in patch 1-3), can you pick the rest of this series too?

Al,

Not sure if you have already re-surfaced from your
csum()/raw_copy_from_user() work completely yet but you had thoughts
about this series iirc.

Aleksa, thoughts?

Thanks!
Christian
