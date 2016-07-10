Reply-To: kernel-hardening@lists.openwall.com
From: Stephan Mueller <smueller@chronox.de>
Date: Sun, 10 Jul 2016 21:29:08 +0200
Message-ID: <3354538.ebClkig31Y@positron.chronox.de>
In-Reply-To: <CAHgaXdJSH3O6q5ZPRRyUwYhCH1M7xQOXGsiynDFNaRjTGebZHg@mail.gmail.com>
References: <CAHgaXdKW4=y-PviWudtMAThuB=GEW-73RejSHRMYNVzLyxP+iA@mail.gmail.com> <CACXcFmm-maS9mpMhXF+boqZ5Os1KYzDpCzYepEwkNJcuuPdbhw@mail.gmail.com> <CAHgaXdJSH3O6q5ZPRRyUwYhCH1M7xQOXGsiynDFNaRjTGebZHg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Subject: Re: [kernel-hardening] Looking for something to WORK ON
To: Shubham Bansal <illusionist.neo@gmail.com>
Cc: kernel-hardening@lists.openwall.com, sandyinchina@gmail.com, tytso@mit.edu, keescook@chromium.org, jsd@av8n.com
List-ID: <kernel-hardening.lists.openwall.com>

Am Sonntag, 10. Juli 2016, 22:12:53 CEST schrieb Shubham Bansal:

Hi Shubham,

> Hi Sandy,
> 
> On Wed, Jul 6, 2016 at 8:44 PM, Sandy Harris <sandyinchina@gmail.com> wrote:
> > Shubham Bansal <illusionist.neo@gmail.com> wrote:
> > > I want to start with linux kernel development and looking for some
> > 
> > project
> > 
> > > where I can contribute.
> > 
> > Nearly all crypto and the address randomisation that is part of kernel
> > hardening depend on good random numbers, for Linux on the random(4)
> > driver. Getting it initialised early enough & well enough is an
> > extremely tricky problem. Several people have proposed solutions but
> > AFAIK none are complete and it might benefit from having fresh eyes
> > take a look, especially if you have a good background in crypto or
> > math.
> 
> I have a basic understanding of crypto as I just graduated. But it sound
> really interesting to work on. I am happy to work on it if you think it
> would be good, But I must tell you that I have to read a lot for this.
> 
> > Not all discussion is here; other relevant lists include
> > linux-crypto@vger.kernel.org and cryptography@metzdowd.com.
> 
> Subscribed.
> 
> > People to
> > look for include the maintainer, tytso@mit.edu, the main person
> > working on the problem here, keescook@chromium.org,
> 
> Should I mail them to get the update and how can I start contributing ?
> 
> > two guys who have
> > proposed drive rewrites that partly solve the problem, me and
> > smueller@chronox.de, and one with a lot of excellent comments,
> > jsd@av8n.com.
> 
> Would it be possible to work with you on this ? I would try my best. I
> would need some help from your side though.
> 
> Looking forward to hearing back from you. I would like to get started with
> it soon.

My code is in the kernel at crypto/jitterentropy.c. It is completely 
standalone and does not require anything, provided the intended architecture 
has either random_get_entropy() or get_cycles implemented. I have tested it on 
bare metal without a kernel. Thus, it can be operational as early as you need 
it.

To make it fully standalone, you have to:

- compile jitterentropy.c and the helper functions listed at the top in 
jitterentropy.c and implemented in jitterentropy_kcapi.c (note, 
jent_fips_enabled is not needed for your purpose)

- statically allocate the memory obtained in jent_entropy_collector_alloc

- ensure serialization as necessary

I strongly suggest that you call jent_entropy_init to ensure that the timer 
has a sufficient high resolution before you collect entropy with 
jent_read_entropy.

Note, I am currently getting help from a big chip vendor tracking down the 
root cause that beyond the analysis of chapter 6.1 in my report.

Ciao
Stephan
