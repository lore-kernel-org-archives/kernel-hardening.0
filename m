Date: Sun, 23 Apr 2017 22:44:51 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
Message-ID: <20170424034451.GA1620@mail.hallyn.com>
References: <20170423235417.12809-1-matt@nmatt.com>
 <20170423235417.12809-2-matt@nmatt.com>
 <20170424010941.GA32715@mail.hallyn.com>
 <7c4370cd-65ce-bc73-b93a-6825b7508f06@nmatt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c4370cd-65ce-bc73-b93a-6825b7508f06@nmatt.com>
Subject: [kernel-hardening] Re: [PATCH v3 1/2] tiocsti-restrict : Add owner user namespace to
 tty_struct
To: Matt Brown <matt@nmatt.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, jmorris@namei.org, gregkh@linuxfoundation.org, jslaby@suse.com, corbet@lwn.net, keescook@chromium.org, akpm@linux-foundation.org, jannh@google.com, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Quoting Matt Brown (matt@nmatt.com):
> On 04/23/2017 09:09 PM, Serge E. Hallyn wrote:
> >Quoting Matt Brown (matt@nmatt.com):
> >>This patch adds struct user_namespace *owner_user_ns to the tty_struct.
> >>Then it is set to current_user_ns() in the alloc_tty_struct function.
> >>
> >>This is done to facilitate capability checks against the original user
> >>namespace that allocated the tty.
> >>
> >>E.g. ns_capable(tty->owner_user_ns,CAP_SYS_ADMIN)
> >>
> >>This combined with the use of user namespace's will allow hardening
> >>protections to be built to mitigate container escapes that utilize TTY
> >>ioctls such as TIOCSTI.
> >>
> >>See: https://bugzilla.redhat.com/show_bug.cgi?id=1411256
> >>
> >>Signed-off-by: Matt Brown <matt@nmatt.com>
> >>---
> >> drivers/tty/tty_io.c | 4 ++++
> >> include/linux/tty.h  | 2 ++
> >> 2 files changed, 6 insertions(+)
> >>
> >>diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
> >>index e6d1a65..03d5ea2 100644
> >>--- a/drivers/tty/tty_io.c
> >>+++ b/drivers/tty/tty_io.c
> >>@@ -161,6 +161,7 @@ static void release_tty(struct tty_struct *tty, int idx);
> >>  *	@tty: tty struct to free
> >>  *
> >>  *	Free the write buffers, tty queue and tty memory itself.
> >>+ *	Decrement the owner_user_ns count.
> >>  *
> >>  *	Locking: none. Must be called after tty is definitely unused
> >>  */
> >>@@ -171,6 +172,7 @@ static void free_tty_struct(struct tty_struct *tty)
> >> 	put_device(tty->dev);
> >> 	kfree(tty->write_buf);
> >> 	tty->magic = 0xDEADDEAD;
> >>+	atomic_dec(&tty->owner_user_ns->count);
> >> 	kfree(tty);
> >> }
> >>
> >>@@ -3191,6 +3193,8 @@ struct tty_struct *alloc_tty_struct(struct tty_driver *driver, int idx)
> >> 	tty->index = idx;
> >> 	tty_line_name(driver, idx, tty->name);
> >> 	tty->dev = tty_get_device(tty);
> >>+	tty->owner_user_ns = current_user_ns();
> >>+	atomic_inc(&tty->owner_user_ns->count);
> >
> >Hi,
> >
> >CONFIG_USER_NS is an option, so unfortunately you need to do
> >
> >	tty->owner_user_ns = get_user_ns(current_user_ns());
> >
> 
> Does this mean I need to also use put_user_ns(tty->owner_user_ns) in
> free_tty_struct instead of atomic_dec(&tty->owner_user_ns->count) ?

Yes, and since in theory the tty could outlive all the tasks in the
user namespace it needs to be put_user_ns() anyway so as to free it
on last put.
