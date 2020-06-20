Return-Path: <SRS0=2S5/=AB=lists.openwall.com=kernel-hardening-return-19030-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF7ABC433DF
	for <kernel-hardening@archiver.kernel.org>; Sat, 20 Jun 2020 14:25:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CC91F23BA6
	for <kernel-hardening@archiver.kernel.org>; Sat, 20 Jun 2020 14:25:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="Wl7MVMYt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC91F23BA6
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19030-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7329 invoked by uid 550); 20 Jun 2020 14:24:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7309 invoked from network); 20 Jun 2020 14:24:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1592663054;
	bh=JuvY6E9cI7JcStIjYECxAe3yf3AL8r2MmuHmABemuRk=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Wl7MVMYtzLAaF3mXHah5MBWUajWsCIyJc3PdZMhTaQ+7bg/Re7VjkaQr6L2xRB8nh
	 4H63sAsWf35UNNgg7mOUsj/BE8HngpPbfZoVjy9NtVKwgk/YFB5tZkluN8XZMBwyY/
	 8sLh0CFbTcR7DqipOk/eZb5F2iXrNb/hEQf9e4mE=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Date: Sat, 20 Jun 2020 16:23:40 +0200
From: Oscar Carter <oscar.carter@gmx.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Oscar Carter <oscar.carter@gmx.com>, Kees Cook <keescook@chromium.org>,
	Ingo Molnar <mingo@redhat.com>, kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel/trace: Remove function callback casts
Message-ID: <20200620142340.GA4330@ubuntu>
References: <20200614070154.6039-1-oscar.carter@gmx.com>
 <20200615161738.18d07ce6@oasis.local.home>
 <20200615162245.13d3feff@oasis.local.home>
 <20200617162800.05a12502@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617162800.05a12502@oasis.local.home>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Provags-ID: V03:K1:XcZK8ql4Us3Vf6wLPkia735yxuYpLydI0oVASt5iEcVQKSJyH3N
 6KMQN5zSfXGZ+DYVch+XELmF4CZdjJ7UshiZUtQwOpBf6l5AKKFrxFZlaUN2+R03l0FFkIn
 XM1/PFePcM0gOe9UVa9VU+Lti2fRaj0Pwusf4DtBMVO+lPm0cj4YXL4JvqNoV7LPj/I+UOr
 MqM/ada2N8QFt0HP7u2Aw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:8Nh3S9aszRs=:RhNgaCX2F/qtj0Tay5aVGJ
 OVFp+whK+iPB5KB3Sm6dz4eILf6skw44DbExwxbEEBGDPlvT/buIdprooCdHhk9kBOfv+k7ua
 lHz5tT/nnBx/0rZKczdGF5Uabx/uTf4pBiga0tLZ/DWAfN0Uj8iafR2yGBXqu447Rl24sfwh5
 LvYqJTDAlSBJgV6p5UlO5q+xB5RnTkTHtRxphM15qNHuhmOH+TbXQ1OrRAO22sn0bVcjHySqJ
 oXv+cTHqxqCAaUUWJT6QDXMqaRN6kapFyxIHIMNdm5i9bE7Ugwk9+dsEIPkZ43RsOea+GRqfD
 B/eRd3gZTvW+c2Kbm5j8DSxJTd+ZKnP9s4i9WUJs4nfP3UCD4TfhorvfsFYBGHjqOpOal2pW3
 zHaK+AukPcauXkuW2RCRyZVUEph7eZ20dK9Xa2pYsAYkqjxQautkC3DNkPKVq6sR/nDRgFlTE
 my87bDZGuSd/mFMHXTtMAqrJqRlwR7PZXdbyOgZ1FziHut7AoDXacVLCDB0g5GGjWo5lh9sS4
 hih87z5UlH7/M1So62VjpBO0mWyIMEqIbZDuCUUcnc4zqdrdn882oiJJ9jD+0hlqtHwDYBF87
 MYyjzD9qsSzUxztxSLpRyzAKp3v3uIrFh85wJkH+0D/NZ6tcqY3eA84scBJv0MYo74eaPYjWa
 CAJmw1IHOvn7yzfQmLjoT8o2DMxJUEg7Hu6pcSg4X5atMaNvorjH25kPKoSKP8Dxh9nE8cXES
 1yLkw2POeRBqcaAIV8d3+NsTEh4Pj5xWYE1vDQySvyHsc1oEsuQVvgLe31VJSYDXVqkAgwnfk
 ugom5EYLfu+Zmdnu8t8rFVJVc6YCtm1golshchWqSh4I2/sohwLkfWSDN9lNBhDERjW1ujB4l
 kOy2HJjgFF7TZvo7wrmXGrDJedramdooRB5lU5C/p/8CE2VoEKiK53+o0uA510uR8h5Uvg5eb
 fEWmJjKhyZ+XfOlqrrdqfD53+UjKElvHyRuiTvEVqr4UjIBdlhPZn+O6bqhqvcG4R7JrBEkBx
 4XsTvaPoCH9TW974NmIFaGpIGD1qY9hSxn1i3Vc9pWg9cOqPm2j+oIa5xbu6UNSe3wqVi+vAS
 xudRx5fSn4WktaHpC+FmFmfrsqUA+xdhUPwWFGaE2BYF5p5xfo8jnMpewJ1/yGgwcon2nj6QI
 tkcAw7GBGsa5JL0stdaR6QaW2QuiFbDSEaqac26lmaNOBRRH8csKpVgu/ayfk2DCVoSVal6MA
 dwn0gN8o3tGBLpMur
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 17, 2020 at 04:28:00PM -0400, Steven Rostedt wrote:
> On Mon, 15 Jun 2020 16:22:45 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
> > As I was saying. This typecast is being paranoid, as archs will call
> > the ftrace_ops_list_func directly, and only pass in two parameters.
> >
> > Now one way around this is to instead of having the typecast, I could
> > use linker magic to create another function that I can define without
> > the typecast to get the same effect. Similar to what I did in commit:
> >
> > 46f9469247c6f ("ftrace: Rename ftrace_graph_stub to ftrace_stub_graph"=
)
>
> Would something like this work for you?
>
> -- Steve
>
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vml=
inux.lds.h
> index db600ef218d7..120babd9ba44 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -145,13 +145,18 @@
>   * Need to also make ftrace_stub_graph point to ftrace_stub
>   * so that the same stub location may have different protocols
>   * and not mess up with C verifiers.
> + *
> + * ftrace_ops_list_func will be defined as arch_ftrace_ops_list_func
> + * as some archs will have a different prototype for that function
> + * but ftrace_ops_list_func() will have a single prototype.
>   */
>  #define MCOUNT_REC()	. =3D ALIGN(8);				\
>  			__start_mcount_loc =3D .;			\
>  			KEEP(*(__mcount_loc))			\
>  			KEEP(*(__patchable_function_entries))	\
>  			__stop_mcount_loc =3D .;			\
> -			ftrace_stub_graph =3D ftrace_stub;
> +			ftrace_stub_graph =3D ftrace_stub;	\
> +			ftrace_ops_list_func =3D arch_ftrace_ops_list_func;
>  #else
>  # ifdef CONFIG_FUNCTION_TRACER
>  #  define MCOUNT_REC()	ftrace_stub_graph =3D ftrace_stub;
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index f060838e9cbb..b775d399026e 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -119,14 +119,9 @@ struct ftrace_ops __rcu *ftrace_ops_list __read_mos=
tly =3D &ftrace_list_end;
>  ftrace_func_t ftrace_trace_function __read_mostly =3D ftrace_stub;
>  struct ftrace_ops global_ops;
>
> -#if ARCH_SUPPORTS_FTRACE_OPS
> -static void ftrace_ops_list_func(unsigned long ip, unsigned long parent=
_ip,
> -				 struct ftrace_ops *op, struct pt_regs *regs);
> -#else
> -/* See comment below, where ftrace_ops_list_func is defined */
> -static void ftrace_ops_no_ops(unsigned long ip, unsigned long parent_ip=
);
> -#define ftrace_ops_list_func ((ftrace_func_t)ftrace_ops_no_ops)
> -#endif
> +/* Defined by vmlinux.lds.h see the commment above arch_ftrace_ops_list=
_func for details */
> +void ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
> +			  struct ftrace_ops *op, struct pt_regs *regs);
>
>  static inline void ftrace_ops_init(struct ftrace_ops *ops)
>  {
> @@ -6859,21 +6854,23 @@ __ftrace_ops_list_func(unsigned long ip, unsigne=
d long parent_ip,
>   * Note, CONFIG_DYNAMIC_FTRACE_WITH_REGS expects a full regs to be save=
d.
>   * An architecture can pass partial regs with ftrace_ops and still
>   * set the ARCH_SUPPORTS_FTRACE_OPS.
> + *
> + * In vmlinux.lds.h, ftrace_ops_list_func() is defined to be
> + * arch_ftrace_ops_list_func.
>   */
>  #if ARCH_SUPPORTS_FTRACE_OPS
> -static void ftrace_ops_list_func(unsigned long ip, unsigned long parent=
_ip,
> -				 struct ftrace_ops *op, struct pt_regs *regs)
> +void arch_ftrace_ops_list_func(unsigned long ip, unsigned long parent_i=
p,
> +			       struct ftrace_ops *op, struct pt_regs *regs)
>  {
>  	__ftrace_ops_list_func(ip, parent_ip, NULL, regs);
>  }
> -NOKPROBE_SYMBOL(ftrace_ops_list_func);
>  #else
> -static void ftrace_ops_no_ops(unsigned long ip, unsigned long parent_ip=
)
> +void arch_ftrace_ops_list_func(unsigned long ip, unsigned long parent_i=
p)
>  {
>  	__ftrace_ops_list_func(ip, parent_ip, NULL, NULL);
>  }
> -NOKPROBE_SYMBOL(ftrace_ops_no_ops);
>  #endif
> +NOKPROBE_SYMBOL(arch_ftrace_ops_list_func);
>
>  /*
>   * If there's only one function registered but it does not support

Thanks for your work and the proper patch sent [1].
I will follow the thread to see if I can help.

[1] https://lore.kernel.org/lkml/20200617165616.52241bde@oasis.local.home/

Regards,
Oscar Carter
