Return-Path: <SRS0=PW54=BD=lists.openwall.com=kernel-hardening-return-19435-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44A65C433E0
	for <kernel-hardening@archiver.kernel.org>; Fri, 24 Jul 2020 16:20:27 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 41B96206EB
	for <kernel-hardening@archiver.kernel.org>; Fri, 24 Jul 2020 16:20:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="GaeOzs9I"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 41B96206EB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19435-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30372 invoked by uid 550); 24 Jul 2020 16:20:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30352 invoked from network); 24 Jul 2020 16:20:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1595607576;
	bh=/YovQTHRJmQubqYrS56yUdbql3XriGKFkBCOtgZjghc=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GaeOzs9IaCTt+GApf7abL2ke091W8LCUGx/EvedNwMuu+isKYh9gAY3pvjf2ikfIX
	 5IlVzzMdZ2d0XU8HAbI91uo+rOUjY3N7BNdOYZJXsvGBP/6OnvoCmWGnauAmwpmOsQ
	 DS2kFfPpKcgVulW/KSuyq4VWxjd2SpLIB3Ff/7EQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Date: Fri, 24 Jul 2020 18:19:21 +0200
From: Oscar Carter <oscar.carter@gmx.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Oscar Carter <oscar.carter@gmx.com>, Ingo Molnar <mingo@redhat.com>,
	Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com, Jann Horn <jannh@google.com>
Subject: Re: [PATCH v2 2/2] kernel/trace: Remove function callback casts
Message-ID: <20200724161921.GA3123@ubuntu>
References: <20200719155033.24201-1-oscar.carter@gmx.com>
 <20200719155033.24201-3-oscar.carter@gmx.com>
 <20200721140545.445f0258@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721140545.445f0258@oasis.local.home>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Provags-ID: V03:K1:w2rXQ2d8NeYY7YeYRSXL/U4Jc2n+Z+Iwf/Adr2RooWuaDA7T18Z
 aPjn5EBcoNxDkgGw8bnt3gCBcrWmzlyMdD3v3FmVhBuZ0rETYVWJV5Q3WXZNWnBVw08pcxg
 Ci1krHnmsf2DPNg0SWNM+wUrPzmmgGdNEp9uzTtEhV35qZRtYYjozENg6FeTTqokxKOcZig
 QsqZXT79uDhL8wJhlCVsQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:O4+txQQMV4s=:OVHu+RCAyHa+xa5XyF4FCp
 XzbhRZ5FB3oU3ATs4seeUGW+32eyT+EgJAQbzYjkrEgS8UnvHL2OVtNtzeyQR+rMi03oRIZUJ
 NsuNrH2qpaxWpxNqG2+tz79ntWZ+TzfbT1rUzWl7yNajkJu4XObHQcoAGaPkXJlrswpMlSumZ
 aayraY61nP/sAgaR7fvyCE32mTpyb5XnRyuuBwTtAPnDfZVFF9TT7O740bi9IUIkW2P9NSJMo
 575OAtEWeLGjlmKssN4rA1QzIBkbeedICGyAuBduFJw367DfbY8ZP8SigxJd37XPzmhoroiek
 I2Ryka9Rws6WRHb7wBt7+AOui6SnGYY3zeh5ulFJLDmsUE2JENEwMhX3SDqmlwz0VXnRyx5nR
 G7mC33KNVF2W/ije1cOmLa8aetQkRIPfLcu//hga+i8ZxpDmtELMdv37VIsmypMu1aeuyd5dm
 zzxpuoM8JgwfOKW7Qgt4lpVLrWqHjr5j+ijqD5SfFazz0nZlki3oD1I9eL/JuA2W4VXDYwv+A
 059Sj76/aBIUCH1vyNRi7Nw0CFzN9BPFPA+F05J0l/L+xgAneLEPnveor1+zdwVSc6QhCWz/S
 +CrwwnzOzLu7ZxBJ96O4QdztFn6t3yb7lngEH+zDPoOey1dN7WBA6NDMOuwCWqZTXHmwlExnO
 VuzGdfYKBADKMPn/bGE1a2vcgi1fuVtEd44Zzy71uxc2by+MfKBO+GSflG12tRPWHcRSC9HVy
 dVg9t+RIH37KwZkCxFzhTrYiAj/0KEfAO1Gc0s+RQRaniBwglvSMf1f/uMuCsgeJvneKUxjCK
 2K6+BxOSLn/S5oBP4xNrSq0DXAb9VngWihho5YoZ5qPRBtBA+zAQAjV2au0JaW1KdomMHMUKw
 m4pVr2VoVtqnpK05RxxmgwUZTr1BRoBX7RZMeY68VfqGwQkHV+3ugRdUaY4tcjwsf/Bz8e85W
 e00vAeVvas0t96k80K3p1nqxekFBjmSjbYpjcHUO0uOwYMoPuiHpBt+VU+BpVj1K3T8AAib+N
 FG2fE2Azg/MS9YIsqCAaRylCN8YUb/WKUrCnpcjE29YOC3sLvKUwhxTkUGIEsv5XHyDervz/m
 KUKjVppdI2Io1lNsc3QbfMC5UfmUv4OMLkocGLsGQynnjws6mKdJWcdAFlV9L0fX1kT62+yOU
 tSnZSyqndVXdxMzDL80ucxpXsQXivzm761/v1CeaC3D4PuReomJgpsM/OeQzns9679YN4Ybrw
 gjzxob5wza6VhsFq+fb8CIy3Zsk/HtiJfZEjm/w==
Content-Transfer-Encoding: quoted-printable

Hi Steven,

On Tue, Jul 21, 2020 at 02:05:45PM -0400, Steven Rostedt wrote:
> On Sun, 19 Jul 2020 17:50:33 +0200
> Oscar Carter <oscar.carter@gmx.com> wrote:
>
> > In an effort to enable -Wcast-function-type in the top-level Makefile =
to
> > support Control Flow Integrity builds, there are the need to remove al=
l
> > the function callback casts.
> >
> > ftrace_ops_list_func() can no longer be defined as ftrace_ops_no_ops()=
.
> > The reason for ftrace_ops_no_ops() is to use that when an architecture
> > calls ftrace_ops_list_func() with only two parameters (called from
> > assembly). And to make sure there's no C side-effects, those archs cal=
l
> > ftrace_ops_no_ops() which only has two parameters, as the function
> > ftrace_ops_list_func() has four parameters.
> >
> > This patch removes the no longer needed function ftrace_ops_no_ops() a=
nd
> > all the function callback casts using the previous defined ftrace_func
> > union and the two function helpers called ftrace_set_ufunc() and
> > ftrace_same_address_ufunc().
>
> Ug, I think I prefer the linker trick better.
>
> >
> > Signed-off-by: Oscar Carter <oscar.carter@gmx.com>
> > ---
> >  kernel/trace/ftrace.c | 48 ++++++++++++++++++++++++++----------------=
-
> >  1 file changed, 29 insertions(+), 19 deletions(-)
> >
> > diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> > index fd8fbb422860..124ccf914657 100644
> > --- a/kernel/trace/ftrace.c
> > +++ b/kernel/trace/ftrace.c
> > @@ -143,9 +143,7 @@ static inline bool ftrace_same_address_ufunc(union=
 ftrace_func *ufunc,
> >  	return (ufunc->ops =3D=3D func);
> >  }
> >  #else
> > -/* See comment below, where ftrace_ops_list_func is defined */
> > -static void ftrace_ops_no_ops(unsigned long ip, unsigned long parent_=
ip);
> > -#define ftrace_ops_list_func ((ftrace_func_t)ftrace_ops_no_ops)
> > +static void ftrace_ops_list_func(unsigned long ip, unsigned long pare=
nt_ip);
> >
> >  static inline void ftrace_set_ufunc(union ftrace_func *ufunc,
> >  				    ftrace_func_no_ops_t func)
> > @@ -198,22 +196,29 @@ static void ftrace_sync_ipi(void *data)
> >  	smp_rmb();
> >  }
> >
> > -static ftrace_func_t ftrace_ops_get_list_func(struct ftrace_ops *ops)
> > +static union ftrace_func ftrace_ops_get_list_func(struct ftrace_ops *=
ops)
> >  {
> > +	union ftrace_func list_func;
> > +
> >  	/*
> >  	 * If this is a dynamic, RCU, or per CPU ops, or we force list func,
> >  	 * then it needs to call the list anyway.
> >  	 */
> >  	if (ops->flags & (FTRACE_OPS_FL_DYNAMIC | FTRACE_OPS_FL_RCU) ||
> >  	    FTRACE_FORCE_LIST_FUNC)
> > -		return ftrace_ops_list_func;
> > +		ftrace_set_ufunc(&list_func, ftrace_ops_list_func);
> > +	else
> > +		list_func.ops =3D ftrace_ops_get_func(ops);
> >
> > -	return ftrace_ops_get_func(ops);
> > +	return list_func;
>
> Is this the same as returning a pointer? It makes me very nervous about
> returning a union. Can a compiler return something allocated on the stac=
k?

Yes, it can. The union is returned by value (copied). So, there is no
problem.

If you don't like to return a union by value, I can modify the prototype
of the ftrace_ops_get_list_func() to the following one:

static void ftrace_ops_get_list_func(struct ftrace_ops *ops,
				     union ftrace_func *list_func)

This way the old local variable "list_func" is removed and we need to pass
the address of a union to this function. Then the function modify the unio=
n.

If you prefer this option I have no problem with the change.

> Also, don't use "ufunc" as that makes me think its a user space variable=
.

Ok, would "bfunc" or "jfunc" be better?
bfunc =3D> blend - function
jfunc =3D> join - function

> >  }
> >
> >  static void update_ftrace_function(void)
> >  {
> > -	ftrace_func_t func;
> > +	union ftrace_func func;
> > +#ifndef CONFIG_DYNAMIC_FTRACE
> > +	union ftrace_func tmp;
> > +#endif
> >
> >  	/*
> >  	 * Prepare the ftrace_ops that the arch callback will use.
> > @@ -225,7 +230,7 @@ static void update_ftrace_function(void)
> >
> >  	/* If there's no ftrace_ops registered, just call the stub function =
*/
> >  	if (set_function_trace_op =3D=3D &ftrace_list_end) {
> > -		func =3D ftrace_stub;
> > +		func.ops =3D ftrace_stub;
> >
> >  	/*
> >  	 * If we are at the end of the list and this ops is
> > @@ -239,21 +244,21 @@ static void update_ftrace_function(void)
> >  	} else {
> >  		/* Just use the default ftrace_ops */
> >  		set_function_trace_op =3D &ftrace_list_end;
> > -		func =3D ftrace_ops_list_func;
> > +		ftrace_set_ufunc(&func, ftrace_ops_list_func);
> >  	}
> >
> >  	update_function_graph_func();
> >
> >  	/* If there's no change, then do nothing more here */
> > -	if (ftrace_trace_function =3D=3D func)
> > +	if (ftrace_trace_function =3D=3D func.ops)
> >  		return;
> >
> >  	/*
> >  	 * If we are using the list function, it doesn't care
> >  	 * about the function_trace_ops.
> >  	 */
> > -	if (func =3D=3D ftrace_ops_list_func) {
> > -		ftrace_trace_function =3D func;
> > +	if (ftrace_same_address_ufunc(&func, ftrace_ops_list_func)) {
> > +		ftrace_trace_function =3D func.ops;
> >  		/*
> >  		 * Don't even bother setting function_trace_ops,
> >  		 * it would be racy to do so anyway.
> > @@ -272,7 +277,9 @@ static void update_ftrace_function(void)
> >  	 * function we want, albeit indirectly, but it handles the
> >  	 * ftrace_ops and doesn't depend on function_trace_op.
> >  	 */
> > -	ftrace_trace_function =3D ftrace_ops_list_func;
> > +	ftrace_set_ufunc(&tmp, ftrace_ops_list_func);
> > +	ftrace_trace_function =3D tmp.ops;
> > +
> >  	/*
> >  	 * Make sure all CPUs see this. Yes this is slow, but static
> >  	 * tracing is slow and nasty to have enabled.
> > @@ -287,7 +294,7 @@ static void update_ftrace_function(void)
> >  	/* OK, we are all set to update the ftrace_trace_function now! */
> >  #endif /* !CONFIG_DYNAMIC_FTRACE */
> >
> > -	ftrace_trace_function =3D func;
> > +	ftrace_trace_function =3D func.ops;
> >  }
>
> This looks really intrusive for what it's trying to accomplish.

What this patch is trying to accomplish is to remove the warning
-Wcast-function-type in a way that allows the CFI build to get the
necessary info about the prototypes (4 parameters or 2 parameters) of
the functions used for archs that support ftrace ops and for the archs
that don't support ftrace ops. This info is necessary to allow the
compiler to insert a check to guarantee that an indirect call can only
jump to functions that match the prototype. This way, the attack surface
is reduced if an attacker can get some control over the system.

> The linker trick is far less intrusive, and I believe less error prone.

If we use the linker trick, the warning -Wcast-function-type dissapears,
but in a way that makes impossible to the compiler to get the necessary
info about function prototypes to insert the commented check. As far I
know, this linker trick (redirection of a function) is hidden for the
CFI build.

So, in my opinion, the linker trick is not suitable if we want to protect
the function pointers of the ftrace subsystem against an attack that
modifiy the normal flow of the kernel.

> -- Steve

Thanks,
Oscar Carter

> >
> >  static void add_ftrace_ops(struct ftrace_ops __rcu **list,
> > @@ -2680,6 +2687,7 @@ void ftrace_modify_all_code(int command)
> >  	int update =3D command & FTRACE_UPDATE_TRACE_FUNC;
> >  	int mod_flags =3D 0;
> >  	int err =3D 0;
> > +	union ftrace_func func;
> >
> >  	if (command & FTRACE_MAY_SLEEP)
> >  		mod_flags =3D FTRACE_MODIFY_MAY_SLEEP_FL;
> > @@ -2695,7 +2703,8 @@ void ftrace_modify_all_code(int command)
> >  	 * traced.
> >  	 */
> >  	if (update) {
> > -		err =3D ftrace_update_ftrace_func(ftrace_ops_list_func);
> > +		ftrace_set_ufunc(&func, ftrace_ops_list_func);
> > +		err =3D ftrace_update_ftrace_func(func.ops);
> >  		if (FTRACE_WARN_ON(err))
> >  			return;
> >  	}
> > @@ -2705,7 +2714,9 @@ void ftrace_modify_all_code(int command)
> >  	else if (command & FTRACE_DISABLE_CALLS)
> >  		ftrace_replace_code(mod_flags);
> >
> > -	if (update && ftrace_trace_function !=3D ftrace_ops_list_func) {
> > +	ftrace_set_ufunc(&func, ftrace_ops_list_func);
> > +
> > +	if (update && ftrace_trace_function !=3D func.ops) {
> >  		function_trace_op =3D set_function_trace_op;
> >  		smp_wmb();
> >  		/* If irqs are disabled, we are in stop machine */
> > @@ -6890,14 +6901,13 @@ static void ftrace_ops_list_func(unsigned long=
 ip, unsigned long parent_ip,
> >  {
> >  	__ftrace_ops_list_func(ip, parent_ip, NULL, regs);
> >  }
> > -NOKPROBE_SYMBOL(ftrace_ops_list_func);
> >  #else
> > -static void ftrace_ops_no_ops(unsigned long ip, unsigned long parent_=
ip)
> > +static void ftrace_ops_list_func(unsigned long ip, unsigned long pare=
nt_ip)
> >  {
> >  	__ftrace_ops_list_func(ip, parent_ip, NULL, NULL);
> >  }
> > -NOKPROBE_SYMBOL(ftrace_ops_no_ops);
> >  #endif
> > +NOKPROBE_SYMBOL(ftrace_ops_list_func);
> >
> >  /*
> >   * If there's only one function registered but it does not support
> > --
> > 2.20.1
>
