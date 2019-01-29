Subject: Re: [PATCH 0/3] gcc-plugins: Introduce stackinit plugin
References: <20190123110349.35882-1-keescook@chromium.org>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <874b8c23-068b-f8e7-2168-12947c06e145@linux.com>
Date: Tue, 29 Jan 2019 03:12:24 +0300
MIME-Version: 1.0
In-Reply-To: <20190123110349.35882-1-keescook@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Laura Abbott <labbott@redhat.com>, xen-devel@lists.xenproject.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org, linux-usb@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, dev@openvswitch.org, linux-kbuild@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, Greg KH <gregkh@linuxfoundation.org>, Jann Horn <jannh@google.com>, William Kucharski <william.kucharski@oracle.com>, Jani Nikula <jani.nikula@linux.intel.com>, Edwin Zimmerman <edwin@211mainstreet.net>, Matthew Wilcox <willy@infradead.org>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 23.01.2019 14:03, Kees Cook wrote:
> This adds a new plugin "stackinit" that attempts to perform unconditional
> initialization of all stack variables

Hello Kees! Hello everyone!

I was curious about the performance impact of the initialization of all stack
variables. So I did a very brief test with this plugin on top of 4.20.5.

hackbench on Intel Core i7-4770 showed ~0.7% slowdown.
hackbench on Kirin 620 (ARM Cortex-A53 Octa-core 1.2GHz) showed ~1.3% slowdown.

This test involves the kernel scheduler and allocator. I can't say whether they
use stack aggressively. Maybe performance tests of other subsystems (e.g.
network subsystem) can show different numbers. Did you try?

I've heard a hypothesis that the initialization of all stack variables would
pollute CPU caches, which is critical for some types of computations. Maybe some
micro-benchmarks can disprove/confirm that?

Thanks!
Best regards,
Alexander
