Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170116164944.GA28984@kroah.com>
References: <20170116164944.GA28984@kroah.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 17 Jan 2017 09:23:16 -0800
Message-ID: <CAGXu5jL1tRod_vLjMgiSac0=DfMhZQnJP=QNZ2HgQDeE=4oFAA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH 0/4] make call_usermodehelper a bit more "safe"
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Thomas Sailer <t.sailer@alumni.ethz.ch>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Johan Hovold <johan@kernel.org>, Alex Elder <elder@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, David Howells <dhowells@redhat.com>, NeilBrown <neilb@suse.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jan 16, 2017 at 8:49 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> Hi all,
>
> Here's a second cut at my attempt to make call_usermodehelper a bit more
> "safe".  It includes some patches from my previous series, and one new
> one.  In all, this is a much smaller patchset, with better functionality
> in the end.
>
> The issue is that if you end up getting write access to kernel memory,
> if you change the string '/sbin/hotplug' to point to
> '/home/hacked/my_binary', then the next uevent that the system makes
> will call this binary instead of the "trusted" one.
>
> This series addresses this issue by doing two different things.  The
> first 2 patches move a lot of existing call_usermodehelper binaries to
> read-only memory, preventing them from being able to be changed at all.
>
> The last patch introduces a new configuration option,
> STATIC_USERMODEHELPER.  This option routes all call_usermodehelper()
> calls to a single userspace binary.  That binary can then
> filter/mediate/blacklist/whitelist/whatever the "real" usermodehelper
> binaries and call them as needed (it determines the real one by looking
> at the first argument.)
>
> The location of this new binary can be set with the
> STATIC_USERMODEHELPER_PATH configuration option.
>
> If the user wants call_usermodehelper() to be disabled entirely,
> STATIC_USERMODEHELPER_PATH can be set to "", which will cause all
> call_usermodehelper() calls to do nothing, but return successful.
>
> Many thanks to the reviewers of the last patch series for their hints on
> how to mark strings properly to live in read-only memory always, and to
> Neil Brown for the idea of STATIC_USERMODEHELPER.
>
> If there are no complaints about these patches, I'll take them through
> my driver-core tree.

I like it! More things into .rodata. :)

Consider all three patches:

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Nexus Security
