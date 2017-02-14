Date: Tue, 14 Feb 2017 16:19:03 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170214161902.GH23718@leverpostej>
References: <20170118095155.5e3bf976@kaiwan-T460>
 <90224a2d-2bfc-8c1e-1f2c-ca5bfbdb4879@redhat.com>
 <20170203101949.4c6908be@kaiwan-T460>
 <CAGXu5jLUdxDkjZ8Qndui1=5LC-_eavCpsgAqRa7RbdBUVdSsEg@mail.gmail.com>
 <20170209090714.63ce6333@kaiwan-T460>
 <CAGXu5jLDnsaJ-PXZB6fwGEvi8pt9rehk76VWeVsq9m66pnrrVQ@mail.gmail.com>
 <CAPDLWs8iS_xU0uQHKU1h6HmqP-oqAfK1qAxDpis_JyPSGVGLug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAPDLWs8iS_xU0uQHKU1h6HmqP-oqAfK1qAxDpis_JyPSGVGLug@mail.gmail.com>
Subject: Re: [kernel-hardening] Merge in PAX_MEMORY_SANITIZE work from grsec
 to linux-next
To: Kaiwan N Billimoria <kaiwan@kaiwantech.com>
Cc: Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, nd@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 14, 2017 at 01:34:38PM +0530, Kaiwan N Billimoria wrote:
> >> diff --git a/mm/page_poison.c b/mm/page_poison.c
> >> index 2e647c6..b45bc0a 100644
> >> --- a/mm/page_poison.c
> >> +++ b/mm/page_poison.c
> >> @@ -49,6 +49,19 @@ struct page_ext_operations page_poisoning_ops = {
> >>          .init = init_page_poisoning,
> >>  };
> >>
> >> +#ifdef CONFIG_MEMORY_SANITIZE
> >> +static int __init memory_sanitize_init(void)
> >> +{
> >> +    /* With 'memory sanitize' On, page poisoning Must be turned on */
> >> +    if (IS_ENABLED(CONFIG_MEMORY_SANITIZE)) {
> >> +        want_page_poisoning = true;
> >> +        __page_poisoning_enabled = true;
> >> +    }
> >> +    return 0;
> >> +}
> >> +early_initcall(memory_sanitize_init);
> >> +#endif
> >
> > The ifdef and the IS_ENABLED seem redundant to me. I'd drop the ifdef.
> 
> An academic question perhaps- am not clear as to why the IS_ENABLED()
> is preferable to an #ifdef. I thought eliminating a runtime 'if'
> condition (by using an ifdef) is more optimal than the "if
> IS_ENABLED(foo)"? Or (probably) does the compiler optimize it out
> regardless (assuming that CONFIG_MEMORY_SANITIZE is not selected of
> course)?

We expect the compiler to optimize the code out, since IS_ENABLED(x) is
a compile-time constant.

As for why it's preferable, it has several benefits.

For one thing, using if (IS_ENABLED(x)) means that we always get build
coverage of the code predicated on the config option, so it's harder to
accidentally break some build configurations.

For another, it composes more nicely with other conditionals, which is
useful when you have a condition that depends on several config options,
or config options and runtime expressions.

e.g. something like:

	if (IS_ENABLED(FOO) && IS_ENABLED(BAR) && runtime_option)
		do_combination_thing();
	else if (IS_ENABLED(BAR))
		do_bar_only_thing();
	else
		do_other_thing();

... is much more painful to write using ifdefs.

Generally, it's nicer for people to deal with than ifdeffery. It's
easier for people to match braces in well-formatted code than it is to
match #ifdef #endif pairs.

Thanks,
Mark.
