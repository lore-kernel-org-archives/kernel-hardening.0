Return-Path: <SRS0=s6qZ=5N=lists.openwall.com=kernel-hardening-return-18275-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6BF8C43331
	for <kernel-hardening@archiver.kernel.org>; Sat, 28 Mar 2020 22:55:01 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0986A20714
	for <kernel-hardening@archiver.kernel.org>; Sat, 28 Mar 2020 22:55:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0986A20714
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18275-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 4066 invoked by uid 550); 28 Mar 2020 22:54:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 4044 invoked from network); 28 Mar 2020 22:54:54 -0000
Date: Sat, 28 Mar 2020 23:54:36 +0100
From: Alexey Gladkov <gladkov.alexey@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux API <linux-api@vger.kernel.org>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	Linux Security Module <linux-security-module@vger.kernel.org>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Daniel Micay <danielmicay@gmail.com>,
	Djalal Harouni <tixxdz@gmail.com>,
	"Dmitry V . Levin" <ldv@altlinux.org>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@kernel.org>,
	"J . Bruce Fields" <bfields@fieldses.org>,
	Jeff Layton <jlayton@poochiereds.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v10 8/9] proc: use human-readable values for hidehid
Message-ID: <20200328225436.m3f72nutyq352i2w@comp-core-i7-2640m-0182e6>
References: <20200327172331.418878-1-gladkov.alexey@gmail.com>
 <20200327172331.418878-9-gladkov.alexey@gmail.com>
 <202003281321.A69D9DE45@keescook>
 <20200328211453.w44fvkwleltnc2m7@comp-core-i7-2640m-0182e6>
 <202003281451.88C7CBD23C@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202003281451.88C7CBD23C@keescook>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.1 (raptor.unsafe.ru [5.9.43.93]); Sat, 28 Mar 2020 22:54:43 +0000 (UTC)

On Sat, Mar 28, 2020 at 02:52:55PM -0700, Kees Cook wrote:
> On Sat, Mar 28, 2020 at 10:14:53PM +0100, Alexey Gladkov wrote:
> > On Sat, Mar 28, 2020 at 01:28:28PM -0700, Kees Cook wrote:
> > > On Fri, Mar 27, 2020 at 06:23:30PM +0100, Alexey Gladkov wrote:
> > > > [...]
> > > > +	if (!kstrtouint(param->string, base, &result.uint_32)) {
> > > > +		ctx->hidepid = result.uint_32;
> > > 
> > > This need to bounds-check the value with a call to valid_hidepid(), yes?
> > 
> > The kstrtouint returns 0 on success and -ERANGE on overflow [1].
> 
> No, I mean, hidepid cannot be just any uint32 value. It must be in the
> enum. Is that checked somewhere else? It looked like the call to
> valid_hidepid() was removed.

The valid_hidepid() is called after parsing the hidepid parameter value.
Yes, it can be called inside this condition.

-- 
Rgrds, legion

