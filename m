MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CA+55aFxiDKfe6VCM+aV2OgnkzMpP+iz+rn2k25_Qa_QLex=pPQ@mail.gmail.com>
References: <1511803118-2552-1-git-send-email-tixxdz@gmail.com>
 <1511803118-2552-6-git-send-email-tixxdz@gmail.com> <CA+55aFxfO1i1LS9dPTTCf50ovWPXcq6BE9mKiq_FxWSm4iE8Mg@mail.gmail.com>
 <CAEiveUcvKbuJMB5801jdRosxYn+CZ4E=pfvXNrhuOrXXbw4ZBQ@mail.gmail.com>
 <CA+55aFzx2eM+wVrjQEfkE-G8E9OVLcdo6vk0fDMwZNu2sh1oCQ@mail.gmail.com>
 <1100603534.56586.1511871419952@ichabod.co-bxl> <20171128193243.4fymnjk7fplqw62x@thunk.org>
 <CAGXu5jLtBjLSe5mbe5sYSao1o67ezkkQq_u3md9646rRfi3cCQ@mail.gmail.com>
 <CA+55aFzvaFR1skBFKwT1QPnKqxaLqCuq33FCuYz8DP7MjKkgNg@mail.gmail.com>
 <CAGXu5j+OzbUAcqVBuC8QoY-ZiA9Xw6Uf9kzfzpx9MQHQ1LtxVQ@mail.gmail.com>
 <CA+55aFz0t7cCkePJQ1w44Kw_g5nns1tYJLUOL7f-c7vriqkFig@mail.gmail.com>
 <708003731.69563.1511905898471@ichabod.co-bxl> <CA+55aFzxFQeyk6Mrk50=jzevHpZ78BXz_9nHcHabMWBdM6RC6A@mail.gmail.com>
 <CA+55aFyybavkF8ccQKJsoVAF+MG=J5=e9PxXKU=J_hqCQRZnug@mail.gmail.com>
 <CAGXu5jLU8LqTYM9SYQADeH9wm2npVu4AEuSqvYqi3S+qtjC-Qw@mail.gmail.com>
 <CA+55aFwDfBnMVGfBVkrFFr26tp1y8CUpSf154AuXH+sWyeY5FA@mail.gmail.com>
 <CAGXu5j+Tv4KHytjOtBvG9e53o-pG7h5DjZZkATXbado-HAbKHw@mail.gmail.com> <CA+55aFxiDKfe6VCM+aV2OgnkzMpP+iz+rn2k25_Qa_QLex=pPQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 29 Nov 2017 13:17:26 -0800
Message-ID: <CAGXu5jJQnokKL2MdbQgOhBJ_RMHVvsw4u27Ds=4Jq3Ys=mjtRg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v5 next 5/5] net: modules: use
 request_module_cap() to load 'netdev-%s' modules
To: Linus Torvalds <torvalds@linux-foundation.org>, Djalal Harouni <tixxdz@gmail.com>, Jessica Yu <jeyu@kernel.org>
Cc: LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Nov 29, 2017 at 10:46 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Nov 29, 2017 at 10:30 AM, Kees Cook <keescook@chromium.org> wrote:
>> On Tue, Nov 28, 2017 at 4:50 PM, Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>>>
>>> Just thinking about the DCCP case, where networking people actually
>>> knew it was pretty deprecated and had no real maintainer, I think one
>>> thing to look at would be simply a per-module flag.
>>>   [ ... ]
>>> Does that sound reasonable?
>>
>> Yeah, I think I see the way forward here; thanks for the discussion!
>
> Note: I don't want to really force that per-module flag if it ends up
> being painful, I was really just thinking that considering the DCCP
> case, it would be (I think) a really nice solution.
>
> In particular, request_module() ends up having that indirection
> through usermode-helper, which makes it potentially very inconvenient
> to store the "did the original caller have proper capabilities" and
> then check it at actual module load time.

Yeah, for this it seems like the permission _evaluation_ would happen
at request_module() time, and it could pass that as a module argument
to the usermode-helper, so that during load_module(), it would have
all the needed information to take an action:

- was this load considered privileged?
- is this module marked privileged-only?
- what are we configured to do in the case of mismatches?

> So the module flag is technically easy to add, and it's technically
> easy to read at module loading time, but I suspect that it's actually
> annoyingly hard to pass the original request_module() capability
> information around to where we actually read the module.

The clever solution grsecurity uses for this is to pass information as
module loading arguments (mentioned above) in call_modprobe(), and
then read them back in load_module(). This seemed like overkill to me,
but it does allow for delaying the decision on the action.

I think this would only be needed to deal with per-module markings,
though, since all other cases the evaluation and action could happen
at request_module() time. (More on this below.)

> That's why it might be _much_ easier to try to do it per call-site
> instead. It's not quite as fine-grained (because several call-sites do
> things like
>
>         request_module("net-pf-%d-proto-%d", PF_NETLINK, protocol);
>
> that can load a large number of different modules), but if we can get
> away with just saying "this particular callsite is ok, because it only
> loads the bluetooth module that we thing is trustworthy" or "this
> call-site is ok, because you already had to have access to the device
> node", that is going to be much simpler and more straightforward.

This is basically what we've historically already tried to do: limit
request_module() calls to either one or a set of const strings, or to
load with a format template. Removing all the
request_module(whatever_the_user_says) calls has (hopefully) been
completed, though sometimes weird stuff sneaks by.

The difficulty I see here is that it's not always clear which are
expected to be privileged loads or not. Even an analysis[1] of whether
or not request_module() is using a format template doesn't tell us
much. Is it an unprivileged net module like your example above or is
it some privileged device hotplug event like
request_module("ulpi:v%04xp%04x", ulpi->id.vendor, ulpi->id.product)?

> In other words: I think there are at least two different models to go
> after, and there may be practical reasons to prefer one over the
> other.

I would agree, and it's why I thought the original series was good: I
feel like we've already done the harder work of narrowing
request_module() calls by subsystem prefixes over the years, and
separating privilege with a new API didn't make sense to me. The
privileges are a state to check in the existing API, etc. But as I
said, if there's a way forward you're happy with, let's do it. It just
needs to get to the point where an admin can explicitly disable
unprivileged module autoloading with some appropriate level of
granularity.

[email merging your later reply...]
> One possibly interesting approach would be to run the usermode helper
> not as root, but with the credentials of the request_module() caller.
>
> That's arguably the right thing to do (in that request_module() would
> never do anything that the user wouldn't be able to do on their own)
> and probably what we should have done originally, but while it feels
> like a nice solution I suspect it would break pretty much every distro
> out there.
>
> Because they all expect modprobe/kmod to be called as root in the
> original init-namespace.

Dropping to the request_module() privileges for the usermode helper
would absolutely break the world. It would actually be much more
disruptive than the proposed series. :)

One of the (many) problems with module loading is that it changes the
global features available to the kernel: suddenly all existing
processes have access to whatever feature just got loaded (modulo a
syscall path to touch the code). This is a rather ugly from the
perspective of containers: unprivileged module loading can change the
kernel globally for all containers, the load gets triggered to run in
the init userspace, not the container, etc, etc. (Though loading from
the container would be nonsense too.)

So, what we have now is that the permission verification already
happens at and around the existing request_module() calls. Callers are
already checking caps within containers, for example, or isolating
which things can be loaded with subsystem format prefixes, etc. All
the loading logic is being done around the request_module() calls, and
once this is deemed "safe", we explicitly elevate privileges to
init-ns CAP_SYS_MODULE and load the module by way of the usermode
helper's call to finit_module(). As in, we have an intentional
CAP_SYS_MODULE privilege elevation for doing module loading.

What I like about the proposed request_modue_cap() is that is codifies
the specific privilege change "having this cap allows you to gain
CAP_SYS_MODULE to load this possible prefixed subset of modules",
instead of having that logic open-coded near the request_module() call
site. And we can add more of these explicit kinds of calls, but it
won't change the need for a way to say "no privilege elevations should
be allowed".

It still sounds like you'd like to see an explicit change, similar to
the proposed request_module_cap(), that identifies the privilege
expectations on a per-call-site basis. How about this plan:

1) Add request_module_cap(required_cap, module_name_prefix, fmt, fmt_args...)

2) Convert known privileged-but-not-CAP_SYS_MODULE request_module()
callers to request_module_cap(the_needed_cap, prefix, ...)

2) Convert known unprivileged callers to use request_module_cap(0, ...)

3) Add WARN_RATELIMIT for request_module() calls without
CAP_SYS_MODULE to shake out other places where request_module_cap() is
needed.

4) Adapt the original patch series to add the per-process flag that
can block privilege elevations.

This will get us the improvement of removing any unexpectedly
unprivileged request_module() call sites for everyone, and still
provide the optional process flag to mark a process as not allowed to
make change its effective privilege to load a module.

Does this sound workable?

-Kees


[1] Just some greps to see the extent of request_module() use...

We've got a bit over 400 call sites:

$ git grep request_module'\b' | wc -l
438

About a third aren't using a format string, so they're loading either
a specific module or a specific alias:

$ git grep request_module'\b' | grep -v % | grep '"' | wc -l
160

Another third use format strings to load some aliased subset:

$ git grep request_module'\b' | grep % | wc -l
154

The rest construct their strings manually, making them less easy to
trivially examine.

-- 
Kees Cook
Pixel Security
