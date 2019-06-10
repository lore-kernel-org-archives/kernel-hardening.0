Date: Mon, 10 Jun 2019 11:20:43 -0700
From: Kees Cook <keescook@chromium.org>
Subject: Re: Regarding add detection for double-reads
Message-ID: <201906101111.0868D6BE6@keescook>
References: <1EBC98102E7E77409022937977AC6892FF10E6@BGSMSX110.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1EBC98102E7E77409022937977AC6892FF10E6@BGSMSX110.gar.corp.intel.com>
To: "Khajapasha, Mohammed" <mohammed.khajapasha@intel.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 10, 2019 at 05:19:17PM +0000, Khajapasha, Mohammed wrote:
> As discussed over IRC, could you please provide some point on "add detection for double-reads".

Hi!

This was about following up on building a good Coccinelle script that
would warn about cases where the kernel reads from userspace twice at
the same location which may result in bugs like reading the size of a
structure at the start of a structure, allocating a size, then filling
the structure with a second read (at which point the size may have
changed). For example:

struct example {
	unsigned int bytes;
	unsigned int flags;
	u8 data[];
}

int do_user_interface(struct example __user *user_instance)
{
	struct example *instance;
	unsigned int size;

	copy_from_user(&size, user_instance, sizeof(size));
	instance = kmalloc(size, GFP_KERNEL);
	if (!instance)
		return -EINVAL;
	copy_from_user(instance, user_instance, size);
	perform_actions(instance);
}

The "bytes" field of the instance passed to perform_actions() may not
contain the right value, leading to possible heap overflows when
accessing instance->data[]...

What's needed after the second copy_from_user() is:

	if (instance.bytes != size) {
		kfree(instance);
		return -EINVAL;
	}

But _finding_ the cases is what I'd like to nail down and get into the
kernel scripts. The thread that needs following up is here:

https://lore.kernel.org/lkml/20160426222442.GA8104@www.outflux.net


-- 
Kees Cook
