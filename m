Return-Path: <SRS0=4pDO=Y5=lists.openwall.com=kernel-hardening-return-17288-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CF84C5DF60
	for <kernel-hardening@archiver.kernel.org>; Tue,  5 Nov 2019 19:35:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9EE0221882
	for <kernel-hardening@archiver.kernel.org>; Tue,  5 Nov 2019 19:35:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mAp2B7C9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9EE0221882
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17288-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5241 invoked by uid 550); 5 Nov 2019 19:35:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5201 invoked from network); 5 Nov 2019 19:35:01 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=1N/htqrARk7XFY047OGh+oThXywZUGM5Z5FnUPMGMqg=;
        b=mAp2B7C92CaYNdyezgOABPgYdozzzrKQCwyFgzPU45P0lrmWE65Wa74/IxcIEM0gse
         +plntHXcLv2PxlSQKLvNi0xe3bycX/S12xUcEGas8UJUEHmGcagNCeAD81YQjWpMjA0Y
         D5SGZ+NTpst0N9XnSXlaIcC2EledyufG7jq5oeDkseOWdZg1HqGSS2I0P9b5V2P8wb8i
         Kme5OMLEAGw4pfsV9VxXE4knLtXuRVMAr8EA3gGiRKtOnQeE7gfQ+XFh1YL+3MfkDoig
         8TV3iAOxt2ScqHNqgu3AkxoAYRn3LamYtvhgzp0bMtWdOPEZEk349NM8yV9mgFeF7UyQ
         Az2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=1N/htqrARk7XFY047OGh+oThXywZUGM5Z5FnUPMGMqg=;
        b=PaSEzApmnQDVUxuYLkm0il0CudvCK21s/8/A7IetVPS9MBdvLnSuPU93PUtfhZlHwJ
         nQ55rqnDOARS3mpPnwghKlEvbsjjex4aJ+NxTifXBB3cGTUi4zH+SuJ9x/nRlXzfnGT2
         mkt04+1T4uD8cQN9cO4PVcvZ6ALO7EgT89bQE1wnNQZpGEJ3FVdrgPFG7ihIZ/M8kArg
         jq+Wj1hskWabc4aQIrnwiAP15z4WcAXWocN+ILiRhO3X0B6Gjhufn+zU6gNQ3/ONoPGj
         vurViVdofJXrSDjnaIbJ0t5/zRw38lSAOjG7dbWnsAryAO00OpOqqtN2nhvb5f3dGuVb
         n99A==
X-Gm-Message-State: APjAAAWUtPHvj39ppI95XbitDEl+DBgLc+V5TRHopYuQIIbWbqPBkQgE
	1MwVgczQtA99je7c1zR8rPl+wzwJ
X-Google-Smtp-Source: APXvYqxzogIVELW0ABnjq8MFoi/lLyCMWmiDef4qJvDicutDSIOJZuxZL1k8H+rEui8zMJT0shvHwA==
X-Received: by 2002:a17:902:362:: with SMTP id 89mr34042123pld.71.1572982489721;
        Tue, 05 Nov 2019 11:34:49 -0800 (PST)
Date: Tue, 5 Nov 2019 11:34:47 -0800
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
Message-ID: <20191105193446.s4pswwwhrmgk6hcx@ast-mbp.dhcp.thefacebook.com>
References: <20191104172146.30797-1-mic@digikod.net>
 <20191104172146.30797-5-mic@digikod.net>
 <20191105171824.dfve44gjiftpnvy7@ast-mbp.dhcp.thefacebook.com>
 <23acf523-dbc4-855b-ca49-2bbfa5e7117e@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <23acf523-dbc4-855b-ca49-2bbfa5e7117e@digikod.net>
User-Agent: NeoMutt/20180223

On Tue, Nov 05, 2019 at 07:01:41PM +0100, Mickaël Salaün wrote:
> 
> On 05/11/2019 18:18, Alexei Starovoitov wrote:
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
> > 
> > So you're passing two kernel pointers obfuscated as u64 into bpf program
> > yet claiming that the end goal is to make landlock unprivileged?!
> > The most basic security hole in the tool that is aiming to provide security.
> 
> How could you used these pointers without dedicated BPF helpers? This
> context items are typed as PTR_TO_TASK and can't be used without a
> dedicated helper able to deal with ARG_PTR_TO_TASK. Moreover, pointer
> arithmetic is explicitly forbidden (and I added tests for that). Did I
> miss something?

It's a pointer leak.

> 
> > 
> > I think the only way bpf-based LSM can land is both landlock and KRSI
> > developers work together on a design that solves all use cases.
> 
> As I said in a previous cover letter [1], that would be great. I think
> that the current Landlock bases (almost everything from this series
> except the seccomp interface) should meet both needs, but I would like
> to have the point of view of the KRSI developers.
> 
> [1] https://lore.kernel.org/lkml/20191029171505.6650-1-mic@digikod.net/
> 
> > BPF is capable
> > to be a superset of all existing LSMs whereas landlock and KRSI propsals today
> > are custom solutions to specific security concerns. BPF subsystem was extended
> > with custom things in the past. In networking we have lwt, skb, tc, xdp, sk
> > program types with a lot of overlapping functionality. We couldn't figure out
> > how to generalize them into single 'networking' program. Now we can and we
> > should. Accepting two partially overlapping bpf-based LSMs would be repeating
> > the same mistake again.
> 
> I'll let the LSM maintainers comment on whether BPF could be a superset
> of all LSM, but given the complexity of an access-control system, I have
> some doubts though. Anyway, we need to start somewhere and then iterate.
> This patch series is a first step.

I would like KRSI folks to speak up. So far I don't see any sharing happening
between landlock and KRSI. You're claiming this set is a first step. They're
claiming the same about their patches. I'd like to set a patchset that was
jointly developed.

