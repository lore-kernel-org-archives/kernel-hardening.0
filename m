Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <1484591068.1277.3.camel@gmail.com>
References: <1484572984-13388-1-git-send-email-djalal@gmail.com>
 <1484572984-13388-3-git-send-email-djalal@gmail.com> <1484591068.1277.3.camel@gmail.com>
From: Lafcadio Wluiki <wluikil@gmail.com>
Date: Tue, 17 Jan 2017 10:54:50 +0100
Message-ID: <CAOWbf6eu6w=QaonmLXp4dcrH+mGa2a-9M2okw9cePjoCjkt6iA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [PATCH v4 2/2] procfs/tasks: add a simple
 per-task procfs hidepid= field
To: Daniel Micay <danielmicay@gmail.com>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Turning on the hidepid group thing for a tightly managed OS like
Android is much easier than doing that for an established distro,
without breaking compatibility. Moreover using groups for this kind of
sandboxing isn't that great anyway as group memberships are "sticky":
whenever some code had it, it can always get it back, by creating a
setgid binary for it. The prctl() feature has the benefit that hidepid
exceptions cannot be made sticky that way...

I think it's pretty unrealistic for big distros such as Debian/Ubuntu
to move to the hidepid group feature. (I mean, if this was easy, then
somebody would already have done that, hidepid is pretty old after
all). OTOH some other opt-in security features (such as systemd's
PrivateTmp= on Fedora) are pretty well used these days, and I don't
think that the prctl would be any different there. The prctl() is a
very easy-to-grasp boolean-like concept after all.

A big benefit of the prctl is that it makes it easy to lock things
down per-process, i.e. to be more fine-grained than just per-user. For
example, my own user on my own system should probably be able to see
the process tree, to make things easy to administer for me. However,
my web browser running under the same user ID probably should not be
able to see the entire process tree, and with the prctl that's very
easy to set up, as this kind of privilege control does not require
privileges with the prctl patch.

And also, let's not forget: what is opt-in on the kernel level could
actually be made opt-out on the service manager level anyway...

Finally, note that the prctl doesn't conflict with the group thing. It
just makes it easier to adopt on a per-service and even per-process
basis, that's all.

Djalal, thank you very much for picking this up!

On Mon, Jan 16, 2017 at 7:24 PM, Daniel Micay <danielmicay@gmail.com> wrote:
>> This should permit Linux distributions to more comprehensively lock
>> down
>> their services, as it allows an isolated opt-in for hidepid= for
>> specific services. Previously hidepid= could only be set system-wide,
>> and then specific services had to be excluded by group membership,
>> essentially a more complex concept of opt-out.
>
> I think it's a lot easier for them to introduce a proc group and then
> figure out the very few exceptions that are needed vs. requiring a huge
> number of opt-ins. I don't think the issue is difficulty in deploying
> it, it's lack of interest. Android deployed it in 7.x without any major
> issues. A good way to get people to use it would be adding proc groups
> to major distributions and getting systemd to expose a simple toggle for
> this, instead of requiring users to add /proc to fstab (not there by
> default with systemd) and hard-wired the correct proc gid for that
> distribution. Can then file bugs for packages needing the proc group.
> For systemd itself, logind needs it since it drops the capability that
> allows bypassing it. Other than that, it's mostly just polkit.
