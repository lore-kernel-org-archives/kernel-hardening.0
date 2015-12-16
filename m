Reply-To: kernel-hardening@lists.openwall.com
From: Laura Abbott <laura@labbott.name>
Message-ID: <5671B170.1090508@labbott.name>
Date: Wed, 16 Dec 2015 10:46:08 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Looking at PAX_MEMORY_SANITIZE
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

I started looking at PAX_MEMORY_SANITIZE for bringing into the kernel. I thought
I would give a short update on what I've found so far for feedback and the like.

PAX_MEMORY_SANITIZE is used for clearing both the SL*B allocators and the
buddy allocator on free. Arguably, similar behavior exists already as debug
features (SLUB_DEBUG poison, DEBUG_PAGEALLOC for some arches). Given what we're
already finding with features like DEBUG_RODATA though, the sanitization really
needs to be a separate Kconfig not tied to debugging. I debated trying to make
those Kconfigs non-debug but they were tied to other features besides poison/
sanitization.

I've been focusing my efforts on the SL*B allocators. As it stands, the feature
is fairly self-contained and mostly just needs some refactoring. I plan on
expanding the command line option to give a bit more control on where the
sanitization happens. The sanitization currently always happens on the fast path
so my thought was to allow the option of sanitizing only on the slow path.
The existing PaX code also disables cache merging. It's not clear if this is an
additional security measure but the sanitization as written doesn't work with
merging. For at least the first version, slab merging will be disabled when
sanitization is enabled on a slab.

I'm hoping to post actual patches before I go on vacation for the holidays next
week. Early feedback is appreciated as well if I missed anything.

Thanks,
Laura
