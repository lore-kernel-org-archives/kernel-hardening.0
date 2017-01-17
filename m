Reply-To: kernel-hardening@lists.openwall.com
From: "PaX Team" <pageexec@freemail.hu>
Date: Tue, 17 Jan 2017 20:25:49 +0100
MIME-Version: 1.0
Message-ID: <587E6FBD.21621.DC486DE@pageexec.freemail.hu>
In-reply-to: <20170117180746.GN18838@e103592.cambridge.arm.com>
References: <20170113220256.GA57663@beast>, <587E4FDD.31940.D47F642@pageexec.freemail.hu>, <20170117180746.GN18838@e103592.cambridge.arm.com>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: [kernel-hardening] Re: [PATCH] gcc-plugins: Add structleak for more stack initialization
To: Dave P Martin <Dave.Martin@arm.com>
Cc: Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, kernel-hardening@lists.openwall.com, Emese Revfy <re.emese@gmail.com>, "AKASHI, Takahiro" <takahiro.akashi@linaro.org>, park jinbum <jinb.park7@gmail.com>, Daniel Micay <danielmicay@gmail.com>, linux-kernel@vger.kernel.org, spender@grsecurity.net
List-ID: <kernel-hardening.lists.openwall.com>

On 17 Jan 2017 at 18:07, Dave P Martin wrote:

> On Tue, Jan 17, 2017 at 06:09:49PM +0100, PaX Team wrote:
> > On 17 Jan 2017 at 10:42, Dave P Martin wrote:
> >
> > > This can be read with the interpretation you suggest, but the wording
> > > doesn't seem rock-solid.  For the kernel, I guess it's sufficient if
> > > GCC commits to this interpretation though.
> >
> > note that i'm not a language lawyer, merely an interpreter, so take
> > the above with a grain of salt.
> 
> Me neither, but actually I think this interpretation doesn't make sense.
> The implication seems to be that padding initialisation of initialised
> aggregates with automatic storage is guaranteed _only_ if the
> initialiser is incomplete.

however illogical it sounds, that's actually what is implied by the standard
and gcc behaves this way. my test case with a bit more verbose output than
your example (gcc shows in comments what each assignment corresponds to):

------ cut --------
gcc -O2 -x c -S -fverbose-asm -o - - <<EOF
struct s1 {
        char c;
        int l;
};

void f(struct s1*);

void g(void)
{
        struct s1 s1 = {};
        struct s1 s2 = { .c = 1};
        struct s1 s3 = { .l = 2};
        struct s1 s4 = { .c = 3, .l = 4};

        f(&s1);
        f(&s2);
        f(&s3);
        f(&s4);
}
EOF
------ cut --------

> This may or may not be a bug, and may or may not have been fixed in a
> more recent version.

i tested 4.5.4, 6.3 and 7.0 from about a month ago on amd64 and had
consistent results as above. i think it's not a bug but an intentional
optimization but i don't feel like digging it out from the gcc sources :).

> > both examples would be handled by the plugin if the types involved already
> > have a __user annotated field (as neither foo2 nor tv are initialized, only
> > assigned to), otherwise it'd need manual annotation and/or more static analysis.
> 
> Do you see any false positives here?  I would expect a fair number of
> structures that contain __user pointers but that are never copied
> wholesale to userspace, but I've not reviewed in detail.

false positive depends on what you consider a goal ;). for me the structleak
plugin had to serve one specific purpose (initialize a local variable that
would otherwise leak unintended kernel stack content back to userland), everything
else didn't matter. now if you want to move the goalpost and initialize those
and only those variables that get copied to userland but aren't otherwise
guaranteed to be completely initialized then you'll need something much smarter
than the current structleak plugin as it doesn't serve that purpose and will
both overinitialize and fail to initialize affected variables...
