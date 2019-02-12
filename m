MIME-Version: 1.0
References: <20190123110349.35882-1-keescook@chromium.org> <874b8c23-068b-f8e7-2168-12947c06e145@linux.com>
In-Reply-To: <874b8c23-068b-f8e7-2168-12947c06e145@linux.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 12 Feb 2019 09:54:38 -0800
Message-ID: <CAGXu5j+xz8_wkY2rVRML_iq1o7ZoF1jVp2mi73LjxaKuMNw1cw@mail.gmail.com>
Subject: Re: [PATCH 0/3] gcc-plugins: Introduce stackinit plugin
Content-Type: text/plain; charset="UTF-8"
To: Alexander Popov <alex.popov@linux.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Laura Abbott <labbott@redhat.com>, xen-devel <xen-devel@lists.xenproject.org>, Maling list - DRI developers <dri-devel@lists.freedesktop.org>, intel-gfx@lists.freedesktop.org, intel-wired-lan@lists.osuosl.org, Network Development <netdev@vger.kernel.org>, linux-usb@vger.kernel.org, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, dev@openvswitch.org, linux-kbuild <linux-kbuild@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Greg KH <gregkh@linuxfoundation.org>, Jann Horn <jannh@google.com>, William Kucharski <william.kucharski@oracle.com>, Jani Nikula <jani.nikula@linux.intel.com>, Edwin Zimmerman <edwin@211mainstreet.net>, Matthew Wilcox <willy@infradead.org>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jan 28, 2019 at 4:12 PM Alexander Popov <alex.popov@linux.com> wrote:
>
> On 23.01.2019 14:03, Kees Cook wrote:
> > This adds a new plugin "stackinit" that attempts to perform unconditional
> > initialization of all stack variables
>
> Hello Kees! Hello everyone!
>
> I was curious about the performance impact of the initialization of all stack
> variables. So I did a very brief test with this plugin on top of 4.20.5.
>
> hackbench on Intel Core i7-4770 showed ~0.7% slowdown.
> hackbench on Kirin 620 (ARM Cortex-A53 Octa-core 1.2GHz) showed ~1.3% slowdown.

Thanks for looking at this! I'll be including my hackbench
measurements for the v2 here in a moment.

> This test involves the kernel scheduler and allocator. I can't say whether they
> use stack aggressively. Maybe performance tests of other subsystems (e.g.
> network subsystem) can show different numbers. Did you try?

I haven't found a stable network test yet. If someone can find a
reasonable workload, I'd love to hear about it.

> I've heard a hypothesis that the initialization of all stack variables would
> pollute CPU caches, which is critical for some types of computations. Maybe some
> micro-benchmarks can disprove/confirm that?

I kind of think micro-benchmarks aren't so useful because they don't
represent a real-world workload. I've heard people talk about SAP-HANA
as a good test, but I can't get my hands on it. I wonder if anyone has
tried "mysqlslap"?

-- 
Kees Cook
