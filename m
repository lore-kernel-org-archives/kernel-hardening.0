Date: Sun, 04 Jun 2017 00:02:25 +0200
In-Reply-To: <1496510200.29378.1.camel@gmail.com>
References: <20170603055351.16080-1-matt@nmatt.com> <20170603154707.GA19161@openwall.com> <20170603155920.GA25740@kroah.com> <20170603162231.GA20590@openwall.com> <1496510200.29378.1.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Nicolas Belouin <nicolas@belouin.fr>
Message-ID: <685A19F8-2CD9-48C2-824E-9C7D593E67F2@belouin.fr>
Subject: Re: [kernel-hardening] [PATCH v1 1/1] Add Trusted Path Execution as a stackable LSM
To: kernel-hardening@lists.openwall.com, Daniel Micay <danielmicay@gmail.com>, Solar Designer <solar@openwall.com>, Greg KH <greg@kroah.com>
Cc: Matt Brown <matt@nmatt.com>
List-ID: <kernel-hardening.lists.openwall.com>

Well,
I think it would be interesting to have such option if you don't=E2=80=8B =
want to go with a full blown SELinux, but want such feature as TPE=2E The f=
act that you don't configure it from userspace is good, as you can keep a v=
ery minimal system and force an attacker to only use the provided tools to =
attack the system, without being able to alter nor disable the protection a=
t any time=2E


On June 3, 2017 7:16:40 PM GMT+02:00, Daniel Micay <danielmicay@gmail=2Eco=
m> wrote:
>On Sat, 2017-06-03 at 18:22 +0200, Solar Designer wrote:
>> On Sat, Jun 03, 2017 at 05:59:20PM +0200, Greg KH wrote:
>> > But for those systems, and this feature as well, can't a "simple"
>> > apparmor policy do the exact same thing?  Also, I'm sure the
>SELinux
>> > can
>> > do this as well, but I don't know the config language there as
>well=2E
>> >=20
>> > So I think this is already a feature that is supported, it just
>> > takes a
>> > bit more configuration work on the admin=2E
>>=20
>> Yes, that's "a bit" more effort up to the point where almost(?) no
>one
>> would bother=2E  Sometimes simple features can reasonably co-exist with
>> more general frameworks that could also be used to achieve the
>effect=2E
>> So I don't view this as a sufficiently good argument against TPE as a
>> feature on its own=2E
>>=20
>> Alexander
>
>Some thoughts on this, veering a bit into some loosely related topics:
>
>SELinux can cover the same kind of stuff as PaX MPROTECT (execmem,
>execheap, execstack, execmod) and grsecurity TPE (execute and
>execute_no_trans)=2E Android uses it to enforce comparable rules for most
>of the SELinux domains in the base system, but the Android Runtime JIT
>and Chromium JIT (particularly in the WebView) block the equivalent to
>MPROTECT for much of the app layer and Play Services violates rules
>comparable to TPE in the app layer too=2E In CopperheadOS, it's taken to
>completion because the WebView sandbox is force enabled and the Android
>Runtime is set to use full ahead-of-time compilation without the JIT=2E
>Nothing violates the equivalent to the TPE rules in the Android Open
>Source Project=2E The domain for the Chromium sandbox is the only one
>with
>execmem and only the privileged base system really violates the TPE
>style guarantees (system_server/installd can install an app and run it
>in one of the app domains at the very least)=2E
>
>Beyond these features, there's also a distinction between code from
>verified/trusted partitions (i=2Ee=2E covered by dm-verity) and from
>partitions that hold persistent state rather than being pristine
>verified OS partitions=2E There's more to "trust" than just whether only
>root or root / current user can write there=2E Android *mostly* forbids
>the base system from executing code from outside of those verified
>partitions too, but it falls a bit short and that's something else
>that's finished off in CopperheadOS=2E I wouldn't go as far as to say it
>makes verified boot work well for anything beyond the usual guarantees
>for factory resets though=2E There's still a lot of trust in persistent
>state, just not code executed from it by the base system=2E The SELinux
>label usage also needs to be audited to make sure that an attacker
>can't
>persist unverified SELinux labels that are not replaced=2E Verified boot
>is really hard to do in a meaningful way=2E ChromeOS weakened it via
>having an Android userspace in a container since the guarantees dropped
>to those of Android there=2E
>
>I see why people want lightweight, independent implementations of these
>features but I don't have a use for it anymore=2E I'm used to having
>great
>full system SELinux policies as a baseline from the Android Open Source
>Project and being able to tweak those existing policies to accomplish
>targeted goals like these=2E It provides much finer-grained control so it
>can do a lot more and compatibility is easier=2E The one thing it isn't
>capable of dealing with on Android is a dynamic toggle because Android
>uses a static SELinux policy=2E It's not possible to have a toggle for
>things like debugging features exposed via toggles over ADB that
>doesn't
>at least require respawning processes to get them into a different
>debug
>domain=2E That's why perf_event_paranoid=3D3 is needed for Android even i=
f
>an LSM hook is added there and why ptrace_scope=3D2 in CopperheadOS does
>something that SELinux (on Android) and seccomp-bpf can't accomplish=2E
>On
>the other hand, I don't really have any use for TPE since doing it with
>SELinux doesn't interfere with debugging so a toggle isn't needed=2E
>
>There's always the option of making a stub SELinux policy used for
>little more than covering similar ground to MPROTECT and TPE if that is
>really all someone wants=2E The policy would be tiny=2E There can be one
>domain for nearly everything and one for an exception from the rules=2E
>The labelling would be simple too=2E I'm curious how minimal that could
>be, but focusing on only those specific micro issues is probably not
>something people are going to do in practice=2E

Nicolas
