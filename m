From: Kees Cook <keescook@chromium.org>
Date: Fri, 26 May 2017 13:17:04 -0700
Message-Id: <1495829844-69341-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v2 00/20] Introduce struct layout randomization plugin
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, x86@kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

This series brings grsecurity's structure layout randomization plugin
to upstream. The plugin randomizes the layout of selected structures at
compile time, as a probabilistic defense against attacks that need to
know the layout of structures within the kernel. This is most useful for
"in-house" kernel builds where the neither the randomization seed nor
other build artifacts are made available to an attacker. While less useful
for distribution kernels (where the randomization seed must be exposed for
third party kernel module builds), it still has some value there since now
all kernel builds would need to be tracked by an attacker.

One requirement of the plugin is that randomized structures must use
designated initializers. Many of these have been landing already as
I've been sending them over the past couple months, but there are
still some stragglers, which are included here.

Another area to address are places where randomized structures are cast
to other structures, since there may be implicit positional details
that need to be addressed. Luckily, there are only a few of these false
positives, and they have been worked around either by adjusting the source
(e.g. correctly using ERR_CAST() or container_of()) or whitelisting them
in the plugin. Some of these fixes have landed already, again with
stragglers included here.

The plugin selects structures in two ways: manually marked with the
new __randomize_layout annotation, or automatically when a structure
is found to consist entirely of function pointers (which can be opted
out of with the new __no_randomize_layout annotation).

A structure that is especially sensitive and regularly abused in
exploits is task_struct, but randomizing it requires some special
handling due to some fields needing to be at the start and end. To
deal with this, an internal anonymous struct is used to mark the
portion that will be randomized. I'd love feedback on whether I
should bite the bullet and perform indenting or violate indenting
rules to avoid a massive white-space change. Also is the problem
that older GCC seems to balk at its use, which I have not figured
out yet.

As already mentioned, the bulk of this feature and annotations are ported
over from grsecurity. The implementation is almost entirely identical
to the original code written by the PaX Team and Brad Spengler. The
changes are an addition of improved designated initializer markings,
a whitelisting mechanism, many false positive fixes, and a different
approach to handling the task_struct randomization.

I've been doing boot tests with instrumentation showing successfully
changing offsets within the task_struct, which ran overnight without
problems. So far, the 0day builder hasn't alerted on anything either.

This series is based on next-20170525.

I intend to push patches 1 through 18 into linux-next if there are no
objections. The task_struct change needs some more attention, and I
continue to wait on ACPICA to take the changes in the final patch.

Patches are:

[PATCH 01/20] NFS: Avoid cross-structure casting
	Fix to use ERR_CAST()

[PATCH 02/20] gcc-plugins: Detail c-common.h location for GCC 4.6
	Update documentation about GCC 4.6 version file locations.

[PATCH 03/20] compiler: Add __designated_init annotation
	Introduce annotation for designated initializers.

[PATCH 04/20] gcc-plugins: Add the randstruct plugin
	The plugin itself, with struct auto-detection disabled.

[PATCH 05/20] randstruct: Whitelist struct security_hook_heads cast
[PATCH 06/20] randstruct: Whitelist UNIXCB cast
[PATCH 07/20] randstruct: Whitelist big_key path struct overloading
[PATCH 08/20] randstruct: Whitelist NIU struct page overloading
	Whitelist a number of false positives that do not have
	trivial source corrections to be made.

[PATCH 09/20] randstruct: Mark various structs for randomization
	Adds the manual annotation for structures to randomize.

[PATCH 10/20] randstruct: opt-out externally exposed function pointer
	Opt out of some externally-exposed structs that would be
	otherwise automatically randomized.

[PATCH 11/20] randstruct: Disable randomization of ACPICA structs
	Opt out of ACPICA randomization.

[PATCH 12/20] sgi-xp: Use designated initializers
[PATCH 13/20] drm/amdgpu: Use designated initializers
[PATCH 14/20] drm/amd/powerplay: Use designated initializers
[PATCH 15/20] mtk-vcodec: Use designated initializers
	The remaining designated initializer fixes for automatic
	struct randomization.

[PATCH 16/20] ntfs: Use ERR_CAST() to avoid cross-structure cast
[PATCH 17/20] ocfs2: Use ERR_CAST() to avoid cross-structure cast
	The remaining cast fixes for automatic struct randomization.

[PATCH 18/20] randstruct: Enable function pointer struct detection
	Enables automatic struct randomization.

[PATCH 19/20] [RFC] task_struct: Allow randomized layout
	Tricky anonymous struct within task_struct...

[PATCH 20/20] ACPICA: Use designated initializers
	Proposed upstream ACPICA solution for designated initializers...

Testing/feedback appreciated!

-Kees
