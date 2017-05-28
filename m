Date: Sat, 27 May 2017 21:55:22 -0700
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20170528045522.GB5045@infradead.org>
References: <1495829844-69341-1-git-send-email-keescook@chromium.org>
 <1495829844-69341-12-git-send-email-keescook@chromium.org>
 <20170527084246.GB26844@infradead.org>
 <CAGXu5jKrha8-dU8vjr1U-hadZdaKrztXuo5iJLDXeBWHZS1ajw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKrha8-dU8vjr1U-hadZdaKrztXuo5iJLDXeBWHZS1ajw@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v2 11/20] randstruct: Disable randomization of ACPICA
 structs
To: Kees Cook <keescook@chromium.org>
Cc: Christoph Hellwig <hch@infradead.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Laura Abbott <labbott@redhat.com>, "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Bob Moore <robert.moore@intel.com>, Lv Zheng <lv.zheng@intel.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, May 27, 2017 at 01:03:23PM -0700, Kees Cook wrote:
> On Sat, May 27, 2017 at 1:42 AM, Christoph Hellwig <hch@infradead.org> wrote:
> > On Fri, May 26, 2017 at 01:17:15PM -0700, Kees Cook wrote:
> >> Since the ACPICA source is maintained externally to the kernel, we can
> >> neither switch it to designated initializers nor mark it
> >> __no_randomize_layout. Until ACPICA-upstream changes[1] land to handle the
> >> designated initialization, explicitly skip it in the plugin.
> >>
> >> [1] https://github.com/acpica/acpica/pull/248
> >
> > I'd just overried the ACPIA bullshit process and just include these
> > changes, as they are a major improvement independent of any
> > reandomization.
> 
> Well... I'd rather not. It's been explicitly NAKed by them already,
> which is why I sent the upstream solution (though it's being ignored
> currently).

Send it to linux-keernel again and we'll override their bulllshit.
We can make exceptions from our coding style and preference just because
they are idiots.  And the whole ACPI mess needs urgent de-obsfucation
anyway.
