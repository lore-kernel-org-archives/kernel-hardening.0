Return-Path: <SRS0=OvfR=Y5=lists.openwall.com=kernel-hardening-return-17283-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 769A9C5DF60
	for <kernel-hardening@archiver.kernel.org>; Tue,  5 Nov 2019 17:18:49 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BA654214D8
	for <kernel-hardening@archiver.kernel.org>; Tue,  5 Nov 2019 17:18:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XX5HI5fd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BA654214D8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17283-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27735 invoked by uid 550); 5 Nov 2019 17:18:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27701 invoked from network); 5 Nov 2019 17:18:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=acyehhZ1kInQCOam4ex9rg1irdVyYdAedYo4L8HuhBE=;
        b=XX5HI5fdLsOtra8e6FRnylQV3POlGoUKjN0QnYgWdYOJbhoq4GfEwzEeXeNk2KlNeR
         cVlbwQ56h482SqsmeiyycLjPl/5cQaqbvnnxnAM834DFR1QuK+5nydBQhFrpZjok32Gs
         AR+xXuUBvANEvmAOUphy2n4Zx7YW461y5VxLfF/EtosJl8SnhT+Zr/CsDH5S4y/MHx2S
         ZjxeqFC22NsB4jP94cfp65T/GYZYybPc8LC7uxKNS7jlfkNEFav/I592UcGT0BwJ8FfK
         uA6ngmKqqv2JvvgOcXk+TtukS5gONMHHX01ywSEFKn0OVOWk9FKzUUGoSgwBXWeGoNNH
         I2XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=acyehhZ1kInQCOam4ex9rg1irdVyYdAedYo4L8HuhBE=;
        b=O+FA/M02hHbAuYqnEGtJ762pWE8Kx14uiIz/7BvZ3yfdJEYJLxwCCeIQyTdR8Z8SMN
         xocJdRGv9q36nko1jpERlG90EVt4/83OEHRsBPZl7Hdv9tooYifxaPRbc/g4o1nM0znI
         rmCq8bmWZZ/ozYYyyZKpx12PDMzmzui1eXpwMSlQc5beLyQdWb6i3PF/sR6heWhDQXVb
         M3Y6/BFPSnylJqLgrYsmmx5hVnsEzf7dF4v8P+Dt5hq8J/7cD+qLq1gto6pf8NEm7iVC
         lR9+8WWYhwFUXElHVDQ8FcM03JlK5rYQE4U7i1reGRe9ZwJvwmEdvjX84tVU/WZQayrX
         rU3w==
X-Gm-Message-State: APjAAAUTkRhkZPGx6wdz1FxD4h4nqaocXFJFiJwZRqUqEOfHTpBuWy8F
	nHNieLbgn4qKUIW8TnuopXs=
X-Google-Smtp-Source: APXvYqxfGfRVQ8tyN+3W2wPHBfjDO9cnkSVobGLtqqzKW+U2w79oK6iebqGh0WK8FAFAk8uwenlUKg==
X-Received: by 2002:a17:90a:2326:: with SMTP id f35mr126860pje.134.1572974309032;
        Tue, 05 Nov 2019 09:18:29 -0800 (PST)
Date: Tue, 5 Nov 2019 09:18:26 -0800
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
Cc: linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Casey Schaufler <casey@schaufler-ca.com>,
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
Message-ID: <20191105171824.dfve44gjiftpnvy7@ast-mbp.dhcp.thefacebook.com>
References: <20191104172146.30797-1-mic@digikod.net>
 <20191104172146.30797-5-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191104172146.30797-5-mic@digikod.net>
User-Agent: NeoMutt/20180223

On Mon, Nov 04, 2019 at 06:21:43PM +0100, Mickaël Salaün wrote:
> Add a first Landlock hook that can be used to enforce a security policy
> or to audit some process activities.  For a sandboxing use-case, it is
> needed to inform the kernel if a task can legitimately debug another.
> ptrace(2) can also be used by an attacker to impersonate another task
> and remain undetected while performing malicious activities.
> 
> Using ptrace(2) and related features on a target process can lead to a
> privilege escalation.  A sandboxed task must then be able to tell the
> kernel if another task is more privileged, via ptrace_may_access().
> 
> Signed-off-by: Mickaël Salaün <mic@digikod.net>
...
> +static int check_ptrace(struct landlock_domain *domain,
> +		struct task_struct *tracer, struct task_struct *tracee)
> +{
> +	struct landlock_hook_ctx_ptrace ctx_ptrace = {
> +		.prog_ctx = {
> +			.tracer = (uintptr_t)tracer,
> +			.tracee = (uintptr_t)tracee,
> +		},
> +	};

So you're passing two kernel pointers obfuscated as u64 into bpf program
yet claiming that the end goal is to make landlock unprivileged?!
The most basic security hole in the tool that is aiming to provide security.

I think the only way bpf-based LSM can land is both landlock and KRSI
developers work together on a design that solves all use cases. BPF is capable
to be a superset of all existing LSMs whereas landlock and KRSI propsals today
are custom solutions to specific security concerns. BPF subsystem was extended
with custom things in the past. In networking we have lwt, skb, tc, xdp, sk
program types with a lot of overlapping functionality. We couldn't figure out
how to generalize them into single 'networking' program. Now we can and we
should. Accepting two partially overlapping bpf-based LSMs would be repeating
the same mistake again.

