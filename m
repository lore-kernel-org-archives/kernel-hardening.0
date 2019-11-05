Return-Path: <SRS0=IM3R=Y5=lists.openwall.com=kernel-hardening-return-17287-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 772A1C5DF60
	for <kernel-hardening@archiver.kernel.org>; Tue,  5 Nov 2019 19:31:55 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AA443214B2
	for <kernel-hardening@archiver.kernel.org>; Tue,  5 Nov 2019 19:31:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bG3YzgHY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA443214B2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17287-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1812 invoked by uid 550); 5 Nov 2019 19:31:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1773 invoked from network); 5 Nov 2019 19:31:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=1SeagsDbeuKXlh/lZkZD0AtJ+ZGsb8zVUjbHRp2z3fk=;
        b=bG3YzgHY/KABC6APZVuTRck1R3V3hiIEonbR4Y6UPz+3BbG8+IUrTEUBpY9wx4cLKU
         WvBehL3A5X9T9a4/MuQkX6lGV1mUzk/M1UAZwNbbvjcCQ+BAEHcUN6NxOb/AwuB1eYuz
         JPwltdrZJbOOFMZWqocUM75vGTaHdfq2YeKxFcLsY4+IV1t4WxTicEXPXg6gA0lJCgMN
         Zg0UeDb9sdgfp0s4VwhDafzWQE6UI3QTlWWZUYuLxLv77dGWb2ON8usVq7+K6cnMAi6j
         f+7cChq65Br+qn9tL8e9tjke7GwNCdD/2L5f6mlggr82Vb0pkvSgaoprE3BxmhoXkHxq
         IZQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=1SeagsDbeuKXlh/lZkZD0AtJ+ZGsb8zVUjbHRp2z3fk=;
        b=jEKE7gua4Yfl133oo8KVBFPjEXnhPuXeJwaxoJDc4Qn9wvZDJiGjU4dzbS6IHVtvJy
         VHo4pAMYx3Tqjq8fkz8dwaKuKhOI7xI21hWyHfR7eod5YrSLI68VzQM0Uy46NPYDq7ng
         WzqO1RRuZeZ0zs2/x6oc51yo1MaH0ParT9BVtTzQVk/5V3dzaOgxYKWc9WZ+BziRJFYS
         sTbaAvGVNilFeP9aJLOdBWOBN3Ck/czHysQhWpYxIbxFZw2h8W/843oRa2h12Os8FODb
         wuOOVm/fTkcvZ6yGY5DXLIOLVxrV0Fys1Heb/ZgN31PMnG8faVZ0o3aT2tEJ3ajhwwS1
         r21Q==
X-Gm-Message-State: APjAAAV7WvrBIeLrL4mfTJk7ZrUexScTYkbBKSrrmJTvmz8t5yS/dqqx
	im+CUPrlu0oR9e8OpnkJw5Y=
X-Google-Smtp-Source: APXvYqy/IJZanoWg94nn+q8E66Sh0NTLVCbwR9j2nk1uXc92V5rp3fg98PT8TE2KB5Ylf7r6SRzC+w==
X-Received: by 2002:a17:90a:6283:: with SMTP id d3mr895052pjj.27.1572982295051;
        Tue, 05 Nov 2019 11:31:35 -0800 (PST)
Date: Tue, 5 Nov 2019 11:31:32 -0800
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>,
	linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Daniel Borkmann <daniel@iogearbox.net>,
	David Drysdale <drysdale@google.com>,
	Florent Revest <revest@chromium.org>,
	James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>,
	John Johansen <john.johansen@canonical.com>,
	Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
	KP Singh <kpsingh@chromium.org>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>,
	Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>,
	"Serge E . Hallyn" <serge@hallyn.com>,
	Shuah Khan <shuah@kernel.org>, Stephen Smalley <sds@tycho.nsa.gov>,
	Tejun Heo <tj@kernel.org>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Tycho Andersen <tycho@tycho.ws>, Will Drewry <wad@chromium.org>,
	bpf@vger.kernel.org, kernel-hardening@lists.openwall.com,
	linux-api@vger.kernel.org, linux-security-module@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v13 4/7] landlock: Add ptrace LSM hooks
Message-ID: <20191105193130.qam2eafnmgvrvjwk@ast-mbp.dhcp.thefacebook.com>
References: <20191104172146.30797-1-mic@digikod.net>
 <20191104172146.30797-5-mic@digikod.net>
 <20191105171824.dfve44gjiftpnvy7@ast-mbp.dhcp.thefacebook.com>
 <c5c6b433-7e6a-c8f8-f063-e704c3df4cc6@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c5c6b433-7e6a-c8f8-f063-e704c3df4cc6@schaufler-ca.com>
User-Agent: NeoMutt/20180223

On Tue, Nov 05, 2019 at 09:55:42AM -0800, Casey Schaufler wrote:
> On 11/5/2019 9:18 AM, Alexei Starovoitov wrote:
> > On Mon, Nov 04, 2019 at 06:21:43PM +0100, Mickaël Salaün wrote:
> >> Add a first Landlock hook that can be used to enforce a security policy
> >> or to audit some process activities.  For a sandboxing use-case, it is
> >> needed to inform the kernel if a task can legitimately debug another.
> >> ptrace(2) can also be used by an attacker to impersonate another task
> >> and remain undetected while performing malicious activities.
> >>
> >> Using ptrace(2) and related features on a target process can lead to a
> >> privilege escalation.  A sandboxed task must then be able to tell the
> >> kernel if another task is more privileged, via ptrace_may_access().
> >>
> >> Signed-off-by: Mickaël Salaün <mic@digikod.net>
> > ...
> >> +static int check_ptrace(struct landlock_domain *domain,
> >> +		struct task_struct *tracer, struct task_struct *tracee)
> >> +{
> >> +	struct landlock_hook_ctx_ptrace ctx_ptrace = {
> >> +		.prog_ctx = {
> >> +			.tracer = (uintptr_t)tracer,
> >> +			.tracee = (uintptr_t)tracee,
> >> +		},
> >> +	};
> > So you're passing two kernel pointers obfuscated as u64 into bpf program
> > yet claiming that the end goal is to make landlock unprivileged?!
> > The most basic security hole in the tool that is aiming to provide security.
> >
> > I think the only way bpf-based LSM can land is both landlock and KRSI
> > developers work together on a design that solves all use cases. BPF is capable
> > to be a superset of all existing LSMs
> 
> I can't agree with this. Nope. There are many security models
> for which BPF introduces excessive complexity. You don't need
> or want the generality of a general purpose programming language
> to implement Smack or TOMOYO. Or a simple Bell & LaPadula for
> that matter. SELinux? I can't imagine anyone trying to do that
> in eBPF, although I'm willing to be surprised. Being able to
> enforce a policy isn't the only criteria for an LSM. 

what are the other criteria?

> It's got
> to perform well and integrate with the rest of the system. 

what do you mean by that?

> I see many issues with a BPF <-> vfs interface.

There is no such interface today. What do you have in mind?

> the mechanisms needed for the concerns of the day. Ideally,
> we should be able to drop mechanisms when we decide that they
> no longer add value.

Exactly. bpf-based lsm must not add to kernel abi.

