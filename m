Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
Date: Mon, 8 Feb 2016 20:20:03 -0800
Message-ID: <CAGXu5j+90rXP1H9-w=aa2GqysjCm5GfOLzhz0J_KxYN-jZ1jGg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH 1/3] GCC plugin infrastructure
To: Emese Revfy <re.emese@gmail.com>
Cc: Michal Marek <mmarek@suse.com>, linux-kbuild <linux-kbuild@vger.kernel.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Feb 8, 2016 at 1:31 PM, Emese Revfy <re.emese@gmail.com> wrote:
> On Mon, 8 Feb 2016 21:28:13 +0100
> Michal Marek <mmarek@suse.com> wrote:
>
>> Dne 7.2.2016 v 22:28 Emese Revfy napsal(a):
>> > This patch allows to build the whole kernel with GCC plugins. It was ported from
>> > grsecurity/PaX. The infrastructure supports building out-of-tree modules and
>> > building in a separate directory. Cross-compilation is supported too but
>> > currently only the x86 architecture enables plugins.
>> >
>> > The directory of the gcc plugins is tools/gcc. You can use a file or a directory
>> > there. The plugins compile with these options:
>> >  * -fno-rtti: gcc is compiled with this option so the plugins must use it too
>> >  * -fno-exceptions: this is inherited from gcc too
>> >  * -fasynchronous-unwind-tables: this is inherited from gcc too
>> >  * -ggdb: it is useful for debugging a plugin (better backtrace on internal
>> >     errors)
>> >  * -Wno-narrowing: to suppress warnings from gcc headers (ipa-utils.h)
>> >  * -Wno-unused-variable: to suppress warnings from gcc headers (gcc_version
>> >     variable, plugin-version.h)
>> >
>> > The infrastructure introduces a new Makefile target called gcc-plugins. It
>> > supports all gcc versions from 4.5 to 6.0. The scripts/gcc-plugin.sh script
>> > chooses the proper host compiler (gcc-4.7 can be built by either gcc or g++).
>> > This script also checks the availability of the included headers in
>> > tools/gcc/gcc-common.h.
>> >
>> > The gcc-common.h header contains frequently included headers for GCC plugins
>> > and it has a compatibility layer for the supported gcc versions.
>>
>> The changelog is missing an explanation as to why this needs to be part
>> of the kernel build system. To me it looks like building the kernel with
>> a modified build system and non-default compiler flags, which can be
>> achieved by doing make CC=my-gcc-wrapper or somesuch. But I'd love to be
>> corrected.
>
> These compiler options compile the gcc plugins not the kernel. The new gcc option
> used for building the kernel is the -fplugin option.

Since these plugins will be used as part of kernel builds and
controlled with CONFIG settings in the future, we want to make sure
they're part of the kernel tree itself. The end goal is gaining the
security benefits of the constify and size_overflow plugins, but that
requires the plugin infrastructure itself first. For example, I would
ultimately expect to see constify on by default after some initial
testing.

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
