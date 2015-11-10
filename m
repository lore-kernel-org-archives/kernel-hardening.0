Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 10 Nov 2015 15:44:41 +0000 (GMT)
From: Julia Lawall <julia.lawall@lip6.fr>
In-Reply-To: <20151109054253.GQ18797@mwanda>
Message-ID: <alpine.DEB.2.10.1511101543120.3146@hadrien>
References: <1447018493-20631-1-git-send-email-Julia.Lawall@lip6.fr> <20151108221624.GP18797@mwanda> <alpine.DEB.2.10.1511082220500.2583@hadrien> <20151109054253.GQ18797@mwanda>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH] video: constify geode ops structures
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Joe Perches <joe@perches.com>, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>



On Mon, 9 Nov 2015, Dan Carpenter wrote:

> On Sun, Nov 08, 2015 at 10:24:49PM +0000, Julia Lawall wrote:
> > On Mon, 9 Nov 2015, Dan Carpenter wrote:
> >
> > > Cool.  So, in grsec they use a GCC plugin to make these const
> > > automatically since they only contain function pointers.  There about
> > > 100 struct types marked as __no_const.  Kees would like to adopt the
> > > grsec pluggin approach I expect.  Do you have an idea how many structs
> > > only contain function pointers or how many consts we would have to add
> > > to get the same effect without the plugin?
> >
> > My list has 373 type names.  In the list there are counts for good
> > (already const) and bad (not const).  The sum of the bad values is 2467.
> > The list is below.
> >
> > julia
>
> Fantastic!  Thanks.  We could autogenerate the list of type names and
> make checkpatch.pl complain if we declared those types as non const.
>
> I ran this command to find which functions grsec marks as __no_const.
>
> egrep '(^ struct |^@@|__no_const;)' grsecurity-3.1-4.2.5-201511021814.patch | grep __no_const -B1 | grep -v __no_const | grep -v '^--' | cut -d @ -f 5-  | cut -b 9- | cut -d ' ' -f 1
>
> There are 60 structs declared as __no_const.  For some structs they
> declare a no_const version and use it as needed.  Like this:
> typedef struct net_device_ops __no_const net_device_ops_no_const;
>
> grep __no_const grsecurity-3.1-4.2.5-201511021814.patch | grep typedef | cut -d ' ' -f 3
>
> There are 32 of those.
>
> Then I compared to see if their structs were on your list.  For some
> reason there quite a few one their list which are not on yours.  Out
> of the first 10 about half weren't on your list.  cpu_cache_fns,
> outer_cache_fns, psci_operations, smp_operations, omap_hwmod_soc_ops,
> smp_ops_t.  These are mostly different arches?


I looked at a few of these (outer_cache_fns, psci_operations,
omap_hwmod_soc_ops), and they aren't const to my understanding of const.
Theer is no initialization at the point of declaring the structure.
Instead, the fields are initialized in the code,

julia

> Also bit_table has in int has well as a function pointers but it is on
> their list.  I'm not sure why.  Maybe they are marking structs const
> that I don't know about.
>
> The other trick that they do is they define structs as __do_const if
> they want them to be const by default, which is pretty neat.  This feels
> like it should be a standard GCC feature.  In the meantime we could
> mark things as __do_const and print a sparse warning if it was declared
> as not const.
>
> I have attached the list of __no_const structs.
>
> regards,
> dan carpenter
>
>
>
