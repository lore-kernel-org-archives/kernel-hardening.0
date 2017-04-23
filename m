MIME-Version: 1.0
In-Reply-To: <0c59f0c4-4202-86ad-eddf-c2c6ad11c69c@nmatt.com>
References: <20170423072457.27120-1-matt@nmatt.com> <CAG48ez2jc8NT1mtQrGjJkY-LMyYPzUf50zEh3UNDzs+NtCe2fA@mail.gmail.com>
 <0c59f0c4-4202-86ad-eddf-c2c6ad11c69c@nmatt.com>
From: Jann Horn <jannh@google.com>
Date: Sun, 23 Apr 2017 22:53:16 +0200
Message-ID: <CAG48ez1r_ORVvCFy5F5k=uU7LnLEez8o7oZrx6B4A8D6w9Jm3A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2 1/2] tiocsti-restrict : Add owner user namespace to tty_struct
To: Matt Brown <matt@nmatt.com>
Cc: serge@hallyn.com, jmorris@namei.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, jslaby@suse.com, corbet@lwn.net, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Apr 23, 2017 at 10:23 PM, Matt Brown <matt@nmatt.com> wrote:
> On 04/23/2017 01:02 PM, Jann Horn wrote:
>>
>> On Sun, Apr 23, 2017 at 9:24 AM, Matt Brown <matt@nmatt.com> wrote:
>>>
>>> This patch adds struct user_namespace *owner_user_ns to the tty_struct.
>>> Then it is set to current_user_ns() in the alloc_tty_struct function.
>>>
>>> This is done to facilitate capability checks against the original user
>>> namespace that allocated the tty.
>>>
>>> E.g. ns_capable(tty->owner_user_ns,CAP_SYS_ADMIN)
>>>
>>> This combined with the use of user namespace's will allow hardening
>>> protections to be built to mitigate container escapes that utilize TTY
>>> ioctls such as TIOCSTI.
>>>
>>> See: https://bugzilla.redhat.com/show_bug.cgi?id=1411256
>>>
>>> Signed-off-by: Matt Brown <matt@nmatt.com>
>>> ---
>>>  drivers/tty/tty_io.c | 1 +
>>>  include/linux/tty.h  | 2 ++
>>>  2 files changed, 3 insertions(+)
>>>
>>> diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
>>> index e6d1a65..e774385 100644
>>> --- a/drivers/tty/tty_io.c
>>> +++ b/drivers/tty/tty_io.c
>>> @@ -3191,6 +3191,7 @@ struct tty_struct *alloc_tty_struct(struct
>>> tty_driver *driver, int idx)
>>>         tty->index = idx;
>>>         tty_line_name(driver, idx, tty->name);
>>>         tty->dev = tty_get_device(tty);
>>> +       tty->owner_user_ns = current_user_ns();
>>
>>
>> Why are you not taking a reference to the userns?
>>
>
> current_user_ns() returns the user namespace of the current task. What
> do you mean "not taking a reference to the userns?"

For managing the lifetime of various object types, including
struct user_namespace, the kernel uses reference counting.
You can see that struct user_namespace has a member named
"count" of type atomic_t. This member tracks how many
references to a user namespace exist in the kernel, not counting
some types of temporary references.
Basically, when this counter reaches zero, the kernel assumes that
nothing uses the namespace anymore and frees the
struct user_namespace. Attempting to use the struct user_namespace
after that would cause a use-after-free bug.

This means that when you store a reference to a
user_namespace in a tty_struct, you need to increment the "count"
member of the user_namespace ("take a reference"), and when the
tty_struct is released, you need to decrement the "count" member of
the user_namespace back down ("drop a reference"). To change the
count, you should use the helper functions get_user_ns() and
put_user_ns().
