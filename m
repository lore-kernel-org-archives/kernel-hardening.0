References: <1491513513-84351-1-git-send-email-keescook@chromium.org>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <58dbe0c1-7a5a-8e77-7672-52ee567c2dd0@redhat.com>
Date: Tue, 18 Apr 2017 09:54:26 -0700
MIME-Version: 1.0
In-Reply-To: <1491513513-84351-1-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel-hardening] [PATCH 00/18] Introduce struct layout
 randomization plugin
To: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
Cc: Michael Leibowitz <michael.leibowitz@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 04/06/2017 02:18 PM, Kees Cook wrote:
> This series brings grsecurity's structure layout randomization plugin
> to upstream. The plugin randomizes the layout of selected structures at
> compile time, as a probabilistic defense against attacks that need to
> know the layout of structures within the kernel. While less useful for
> distribution kernels (where the randomization seed must be exposed for
> third party kernel module builds), it still has some value there since
> now all kernel builds would need to be tracked by an attacker. It is
> most useful to "in-house" kernel builds where the randomization seed
> is not available to an attacker.
>      
> One requirement of the plugin is that randomized structures must use
> designated initializers. Many of these have been landing already as
> I've been sending them over the past couple months, but there are
> still some stragglers, which are included here.
> 
> Another area to address are places where randomized structures are
> cast to other structures, since there may be implicit positional
> details that need to be addressed. Luckily, there are only a few
> of these false positives, and they have been worked around either
> by adjusting the source or whitelisting them in the plugin.
> 
> The plugin selects structures in two ways: manually marked with the
> new __randomize_layout annotation, or automatically when a structure
> is found to consist entirely of function pointers (which can be opted
> out of with the new __no_randomize_layout annotation).
> 
> A structure that is especially sensitive and regularly abused in
> exploits is task_struct, but randomizing it requires some special
> handling due to some fields needing to be at the start and end. To
> deal with this, an internal anonymous struct is used to mark the
> portion that will be randomized. I'd love feedback on whether I
> should bite the bullet and perform indenting or violate indenting
> rules to avoid a massive white-space change.
> 
> As mentioned, the bulk of this feature is ported over from grsecurity.
> The implementation is almost entirely identical to the original code
> written by Brad Spengler and the PaX Team and Brad Spengler. The
> changes are addition of improved designated initializer markings,
> a whitelisting mechanism, and a different approach to handling the
> task_struct randomization.
> 
> I've been doing boot tests with instrumentation showing successfully
> changing offsets within the task_struct, which ran overnight without
> problems. So far, the 0day builder hasn't alerted on anything, but
> it's probably still a bit early.
> 
> This series is based on next-20170404.
> 
> Patches are:
> 
> [PATCH 01/18] gcc-plugins: Add the randstruct plugin
> 	The plugin itself, with struct auto-detection disabled.
> 
> [PATCH 02/18] compiler: Add __designated_init annotation
> [PATCH 03/18] randstruct: Set designated_init attribute
> 	Adds marking of structures needing designated initialization.
> 	
> [PATCH 04/18] randstruct: Differentiate bad cast warnings
> 	Minor clarifications to bad cast warning output.
> 
> [PATCH 05/18] af_unix: Use designated initializers
> 	Designated initializer fix for af_unix (taken for -next already)
> 	https://lkml.org/lkml/2017/4/6/846
> 
> [PATCH 06/18] NFS: Avoid cross-structure casting
> 	Avoids a false positive in casting (waiting for feedback)
> 	https://lkml.org/lkml/2017/4/5/530
> 
> [PATCH 07/18] randstruct: Whitelist struct security_hook_heads cast
> [PATCH 08/18] randstruct: Whitelist UNIXCB cast
> 	Whitelist two more false positive cases where source-level
> 	fixes aren't obvious/possible.
> 
> [PATCH 09/18] randstruct: Mark various structs for randomization
> 	Adds the manual annotation for structures to randomize.
> 
> [PATCH 10/18] scsi/bfa: use designated initializers
> [PATCH 11/18] scsi: qedi,qedf: Use designated initializers
> [PATCH 12/18] ovl: Use designated initializers
> 	The remaining designated initializer fixes for automatic
> 	struct randomization.
> 
> [PATCH 13/18] randstruct: opt-out externally exposed function pointer
> 	Opt out of some externally-exposed structs that would be
> 	otherwise automatically randomized.
> 
> [PATCH 14/18] randstruct: Disable randomization of ACPICA structs
> 	Temporary disabling of automatic randomization of ACPICA struct.
> 	
> [PATCH 15/18] randstruct: Enable function pointer struct detection
> 	Enables automatic struct randomization.
> 
> [PATCH 16/18] task_struct: Allow randomized layout
> 	Adds selected portion of task_struct to be randomized.
> 
> [PATCH 17/18] sgi-xp: Use designated initializers
> 	Enable randomization of sgi-xp struct, pending feedback.
> 	https://lkml.org/lkml/2017/3/29/808
> 
> [PATCH 18/18] ACPICA: Use designated initializers
> 	Enable randomization of ACPICA struct, pending feedback.
> 	https://github.com/acpica/acpica/pull/248/
> 
> Testing/feedback appreciated!
> 
> -Kees
> 

A few more reports from the Fedora config

ipc/sem.c: In function ‘newary’:
ipc/sem.c:507:16: note: found mismatched ssa struct pointer types: 
‘struct sem’ and ‘struct sem_array’

   sma->sem_base = (struct sem *) &sma[1];
   ~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~

This looks like a false positive

security/keys/big_key.c:126:15: note: found mismatched rhs struct 
pointer types: ‘struct path’ and ‘void *’

   struct path *path = (struct path *)&prep->payload.data[big_key_path];
                ^~~~
security/keys/big_key.c: In function ‘big_key_free_preparse’:
security/keys/big_key.c:225:16: note: found mismatched rhs struct 
pointer types: ‘struct path’ and ‘void *’

    struct path *path = (struct path *)&prep->payload.data[big_key_path];
                 ^~~~
security/keys/big_key.c: In function ‘big_key_destroy’:
security/keys/big_key.c:255:16: note: found mismatched rhs struct 
pointer types: ‘struct path’ and ‘void *’

    struct path *path = (struct path *)&key->payload.data[big_key_path];
                 ^~~~
security/keys/big_key.c: In function ‘big_key_revoke’:
security/keys/big_key.c:238:15: note: found mismatched rhs struct 
pointer types: ‘struct path’ and ‘void *’

   struct path *path = (struct path *)&key->payload.data[big_key_path];
                ^~~~
security/keys/big_key.c: In function ‘big_key_read’:
security/keys/big_key.c:293:16: note: found mismatched rhs struct 
pointer types: ‘struct path’ and ‘void *’

    struct path *path = (struct path *)&key->payload.data[big_key_path];

I'm not quite sure what's going on here, I think it might be
another false positive?


fs/ocfs2/export.c: In function ‘ocfs2_get_dentry’:
fs/ocfs2/export.c:122:10: note: found mismatched ssa struct pointer 
types: ‘struct dentry’ and ‘struct inode’

    result = (void *)inode;
    ~~~~~~~^~~~~~~~~~~~~~~

This looks similar to the NFS issue

drivers/net/ethernet/sun/niu.c: In function ‘niu_rx_pkt_ignore’:
drivers/net/ethernet/sun/niu.c:3402:10: note: found mismatched ssa 
struct pointer types: ‘struct page’ and ‘struct address_space’

     *link = (struct page *) page->mapping;
     ~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/sun/niu.c: In function ‘niu_process_rx_pkt’:
drivers/net/ethernet/sun/niu.c:3472:10: note: found mismatched ssa 
struct pointer types: ‘struct page’ and ‘struct address_space’

     *link = (struct page *) page->mapping;
     ~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This driver appears to be doing something unique with storing
a page in page->mapping?

The AMD GPU driver has a bunch of warnings about needing to use
explicit initializers.

Thanks,
Laura
