Return-Path: <SRS0=ica8=EI=lists.openwall.com=kernel-hardening-return-20318-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24CB8C00A89
	for <kernel-hardening@archiver.kernel.org>; Mon,  2 Nov 2020 17:30:49 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 53AB521D91
	for <kernel-hardening@archiver.kernel.org>; Mon,  2 Nov 2020 17:30:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 53AB521D91
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20318-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 14135 invoked by uid 550); 2 Nov 2020 17:30:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 14103 invoked from network); 2 Nov 2020 17:30:40 -0000
Date: Mon, 2 Nov 2020 18:30:24 +0100
From: Alexey Gladkov <gladkov.alexey@gmail.com>
To: Jann Horn <jannh@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Linux Containers <containers@lists.linux-foundation.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	Kees Cook <keescook@chromium.org>,
	Christian Brauner <christian@brauner.io>
Subject: Re: [RFC PATCH v1 4/4] Allow to change the user namespace in which
 user rlimits are counted
Message-ID: <20201102173024.oflzudkq6cnolqyr@comp-core-i7-2640m-0182e6>
References: <cover.1604335819.git.gladkov.alexey@gmail.com>
 <2718f7b13189dfd159414efb68e3533552593140.1604335819.git.gladkov.alexey@gmail.com>
 <CAG48ez0zGoB4Pr_+nLKaycCgEUtUrAvLJ89JG1ZbcbjKChMcng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez0zGoB4Pr_+nLKaycCgEUtUrAvLJ89JG1ZbcbjKChMcng@mail.gmail.com>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.1 (raptor.unsafe.ru [5.9.43.93]); Mon, 02 Nov 2020 17:30:29 +0000 (UTC)

On Mon, Nov 02, 2020 at 06:10:06PM +0100, Jann Horn wrote:
> On Mon, Nov 2, 2020 at 5:52 PM Alexey Gladkov <gladkov.alexey@gmail.com> wrote:
> > Add a new prctl to change the user namespace in which the process
> > counter is located. A pointer to the user namespace is in cred struct
> > to be inherited by all child processes.
> [...]
> > +       case PR_SET_RLIMIT_USER_NAMESPACE:
> > +               if (!capable(CAP_SYS_RESOURCE))
> > +                       return -EPERM;
> > +
> > +               switch (arg2) {
> > +               case PR_RLIMIT_BIND_GLOBAL_USERNS:
> > +                       error = set_rlimit_ns(&init_user_ns);
> > +                       break;
> > +               case PR_RLIMIT_BIND_CURRENT_USERNS:
> > +                       error = set_rlimit_ns(current_user_ns());
> > +                       break;
> > +               default:
> > +                       error = -EINVAL;
> > +               }
> > +               break;
> 
> I don't see how this can work. capable() requires that
> current_user_ns()==&init_user_ns, so you can't use this API to bind
> rlimits to any other user namespace.
> 
> Fundamentally, if it requires CAP_SYS_RESOURCE, this probably can't be
> done as an API that a process uses to change its own rlimit scope. In
> that case I would implement this as part of clone3() instead of
> prctl(). (Then init_user_ns can set it if the caller has
> CAP_SYS_RESOURCE. If you want to have support for doing the same thing
> with nested namespaces, you'd also need a flag that the first-level
> clone3() can set on the namespace to say "further rlimit splitting
> should be allowed".)
> 
> Or alternatively, we could say that CAP_SYS_RESOURCE doesn't matter,
> and instead you're allowed to move the rlimit scope if your current
> hard rlimit is INFINITY. That might make more sense? Maybe?

I think you are right. CAP_SYS_RESOURCE is not needed here since you still
cannot exceed the rlimit in the parent user namespace.

-- 
Rgrds, legion

