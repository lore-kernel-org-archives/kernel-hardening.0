Date: Mon, 11 Sep 2017 00:36:16 -0700
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20170911073616.GA23201@infradead.org>
References: <20170907173609.22696-1-tycho@docker.com>
 <20170907173609.22696-11-tycho@docker.com>
 <20170908075519.GD4957@infradead.org>
 <CAGXu5jL8wRg2307wKkGf9ASZHTtYZMwPzn10100-Mfmx9p2=Fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jL8wRg2307wKkGf9ASZHTtYZMwPzn10100-Mfmx9p2=Fg@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v6 10/11] mm: add a user_virt_to_phys symbol
To: Kees Cook <keescook@chromium.org>
Cc: Christoph Hellwig <hch@infradead.org>, Tycho Andersen <tycho@docker.com>, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Marco Benatto <marco.antonio.780@gmail.com>, Juerg Haefliger <juerg.haefliger@canonical.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "x86@kernel.org" <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Sep 08, 2017 at 08:44:22AM -0700, Kees Cook wrote:
> On Fri, Sep 8, 2017 at 12:55 AM, Christoph Hellwig <hch@infradead.org> wrote:
> > On Thu, Sep 07, 2017 at 11:36:08AM -0600, Tycho Andersen wrote:
> >> We need someting like this for testing XPFO. Since it's architecture
> >> specific, putting it in the test code is slightly awkward, so let's make it
> >> an arch-specific symbol and export it for use in LKDTM.
> >
> > We really should not add an export for this.
> >
> > I think you'll want to just open code it in your test module.
> 
> Isn't that going to be fragile? Why not an export?

It is a little fragile, but it is functionality not needed at all by
the kernel, so we should not add it to the kernel image and/or export
it.
