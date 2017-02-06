MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.20.1702031159120.3285@namei.org>
References: <1486055094-4532-1-git-send-email-djalal@gmail.com>
 <1486055094-4532-3-git-send-email-djalal@gmail.com> <alpine.LRH.2.20.1702031159120.3285@namei.org>
From: Djalal Harouni <tixxdz@gmail.com>
Date: Mon, 6 Feb 2017 13:19:30 +0100
Message-ID: <CAEiveUdMtGhw_Wbs1jt4GyVi4Jb06WhRVWAdtxat1gneNS1Uaw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC/PATCH 2/3] security: Add the Timgad module
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, LSM List <linux-security-module@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Lafcadio Wluiki <wluikil@gmail.com>, Dongsu Park <dongsu@endocode.com>, Andy Lutomirski <luto@kernel.org>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, Al Viro <viro@zeniv.linux.org.uk>, Daniel Mack <daniel@zonque.org>, Jann Horn <jann@thejh.net>, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi James,

On Fri, Feb 3, 2017 at 2:02 AM, James Morris <jmorris@namei.org> wrote:
> On Thu, 2 Feb 2017, Djalal Harouni wrote:
>
>> *) The per-process prctl() settings are:
>>     prctl(PR_TIMGAD_OPTS, PR_TIGMAD_SET_MOD_RESTRICT, value, 0, 0)
>>
>>     Where value means:
>>
>> 0 - Classic module load and unload permissions, nothing changes.
>>
>> 1 - The current process must have CAP_SYS_MODULE to be able to load and
>>     unload modules. CAP_NET_ADMIN should allow the current process to
>>     load and unload only netdev aliased modules, not implemented
>>
>> 2 - Current process can not loaded nor unloaded modules.
>>
>> *) sysctl interface supports the followin values:
>>
>> 0 - Classic module load and unload permissions, nothing changes.
>>
>> 1 - Only privileged processes with CAP_SYS_MODULE should be able to load and
>>     unload modules.
>>
>>     To be added: processes with CAP_NET_ADMIN should be able to
>>     load and unload only netdev aliased modules, this is currently not
>>     supported. Other checks for real root without CAP_SYS_MODULE ? ...
>>
>>     (This should be improved)
>>
>> 2 - Modules can not be loaded nor unloaded. Once set, this sysctl value
>>     cannot be changed.
>
> How is this different to just using CAP_SYS_MODULE?

Using only CAP_SYS_MODULE is not sufficient on its own, first we have
the following:

* Some modules can be auto-loaded without any privileges:
  tun, all the tunneling modules, maybe some md drivers, some crypto,
some device drivers... (long list)

* Other network modules require CAP_NET_ADMIN and netdev module prefix.

* Some socket types require CAP_SYS_ADMIN before loading the
corresponding protocol module: phonet sockets...

* Some other operations related to ioctl require CAP_SYS_ADMIN

* Filesystem prefixed modules can be auto-loaded inside user
namespaces, this was discussed in the past, and seems everyone agreed
that there is no harm.

* All the situations where a module requests another module or an
external symbol.

Then comes the rest, manual module loading operations which require
CAP_SYS_MODULE.

Of course all of these features are must have for a usable system.
However as Linux covers lot of use cases, there are situations where
offering users more granularity would be better, restricting the
ability of unprivileged to stack dozens of modules and expose them in
a container/embedded world IMO is worth it. Also CAP_NET_ADMIN is
pretty useful on its own for some services, but at same time maybe we
don't want it to translate to CAP_SYS_MODULE on that node or for that
container.

This is a first RFC to seek feedback, permission checks should be
adapted to cover what everyone think is reasonable. I think that we
definitely need a way to have a usable system/processes but also be
able to restrict *only* a set of processes from auto inserting modules
for various reasons (security, using other net protocols...) We are
already using seccomp, however it does not cover those cases.

Btw do you think it is acceptable to add the security_task_copy() hook
in the first patch ?

The whole approach is based on that hook, otherwise I don't see
another easy way and we have to clash with all other LSMs. This one
make it so easy to stack more minor LSMs.

Thanks!


> --
> James Morris
> <jmorris@namei.org>
>



-- 
tixxdz
