Reply-To: kernel-hardening@lists.openwall.com
From: "PaX Team" <pageexec@freemail.hu>
Date: Tue, 17 Jan 2017 18:09:49 +0100
MIME-Version: 1.0
Message-ID: <587E4FDD.31940.D47F642@pageexec.freemail.hu>
In-reply-to: <20170117104239.GG18838@e103592.cambridge.arm.com>
References: <20170113220256.GA57663@beast>, <587D1D70.26193.89AFE10@pageexec.freemail.hu>, <20170117104239.GG18838@e103592.cambridge.arm.com>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: [kernel-hardening] Re: [PATCH] gcc-plugins: Add structleak for more stack initialization
To: Dave P Martin <Dave.Martin@arm.com>
Cc: Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, kernel-hardening@lists.openwall.com, Emese Revfy <re.emese@gmail.com>, "AKASHI, Takahiro" <takahiro.akashi@linaro.org>, park jinbum <jinb.park7@gmail.com>, Daniel Micay <danielmicay@gmail.com>, linux-kernel@vger.kernel.org, spender@grsecurity.net
List-ID: <kernel-hardening.lists.openwall.com>

On 17 Jan 2017 at 10:42, Dave P Martin wrote:

> On Mon, Jan 16, 2017 at 08:22:24PM +0100, PaX Team wrote:
> > the 'issue' is that before C11 the standard didn't make it clear that in
> > case of a partial initializer list the compiler has to initialize not only
> > the remaining fields but also padding as well.
> 
> Which version of the C11 spec clarifies this?
> 
> The one I'm looking at (n1570, Apr 12 2011) says:
> 
> "6.7.9 21 If there are fewer initializers in a brace-enclosed list than
> there are elements or members of an aggregate, or fewer characters in a
> string literal used to initialize an array of known size than there are
> elements in the array, the remainder of the aggregate shall be
> initialized implicitly the same as objects that have static storage
> duration."
> 
> What is meant by "the remainder of the object" is unclear.

it's less unclear if you also take into account the rest of the
sentence that says "[initialized] the same as objects that have
static storage duration" which in turn is described at 6.7.9p10
where it says among others:

  "if it is an aggregate, every member is initialized (recursively)
   according to these rules, and any padding is initialized to zero bits"

the "and any padding is initialized to zero bits" was the addition
in C11 (which i'm not sure was meant as a new feature for C11 or
just official enshrinement of what had always been meant).

>  Is this just the tail of the object, or all unitialised members --
> which may be sparse in the case of an initialiser with designators? And
> is padding (and if so, which padding) considered to be part of (the
> remainder of) the object for the purpose of this paragraph? 

to me the quote about 'any padding' is for all kinds of padding.
uninitialized members are described in the same paragraph.

> This can be read with the interpretation you suggest, but the wording
> doesn't seem rock-solid.  For the kernel, I guess it's sufficient if
> GCC commits to this interpretation though.

note that i'm not a language lawyer, merely an interpreter, so take
the above with a grain of salt.

> A related, perhaps more interesting issue is that C11 still explicitly
> states that padding is undefined after assignment:

you probably meant 'unspecified'?

> "6.2.6.1 6 When a value is stored in an object of structure or union
> type, including in a member object, the bytes of the object
> representation that correspond to any padding bytes take unspecified
> values.  51)"
> 
> "51) Thus, for example, structure assignment need not copy any padding
> bits."
> 
> which means that in:
> 
> {
>         struct foo foo1 = FOO1_INTIALIZER;
>         struct foo foo2;
> 
>         foo2 = foo1;
> }
> 
> the contents of padding in foo2 is unspecified.
> 
> Similarly, piecemeal initialisation of an object by assigning to every
> member leaves the padding unspecified, e.g.:
> 
> {
>         struct timeval tv;
> 
>         tv.tv_sec = secs;
>         tv.tv_usec = usecs;
> }
> 
> (On most or all arches struct timeval contains no padding, but relying
> implicitly on this is still a bit iffy.)
> 
> 
> It's highly likely that the kernel passes objects resulting from one of
> the above to put_user() and friends.  It would be good if we had a way
> to catch at least some of these.

both examples would be handled by the plugin if the types involved already
have a __user annotated field (as neither foo2 nor tv are initialized, only
assigned to), otherwise it'd need manual annotation and/or more static analysis.
