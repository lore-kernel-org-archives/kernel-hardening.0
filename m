Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: paul.gortmaker@gmail.com
In-Reply-To: <CAGXu5jJbzUueFvrBJvP3qhprKQ95fZqfgo08VvyG5HETL0a4Sw@mail.gmail.com>
References: <20160609163408.37fb77b9@canb.auug.org.au> <5759E871.3040706@gmail.com>
 <CAGXu5jJbzUueFvrBJvP3qhprKQ95fZqfgo08VvyG5HETL0a4Sw@mail.gmail.com>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Fri, 10 Jun 2016 21:05:17 -0400
Message-ID: <CAP=VYLpsyUGzuhN-zrXr3X1JZh2M3dr9FQiazafOwuupaCWt2A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: linux-next: Tree for Jun 9
To: Kees Cook <keescook@chromium.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Linux-Next <linux-next@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Emese Revfy <re.emese@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 9, 2016 at 6:14 PM, Kees Cook <keescook@chromium.org> wrote:
> On Thu, Jun 9, 2016 at 3:06 PM, Sudip Mukherjee
> <sudipm.mukherjee@gmail.com> wrote:

[...]

>> While trying to build x86_64 allmodconfig I am getting:
>> ++ dirname ../scripts/gcc-plugin.sh
>> + srctree=../scripts
>> ++ gcc -print-file-name=plugin
>> + gccplugins_dir=plugin
>> ++ g++ -E -x c++ - -o /dev/null -I../scripts/gcc-plugins -Iplugin/include
>> + plugincc='In file included from <stdin>:1:0:
>> ../scripts/gcc-plugins/gcc-common.h:4:22: fatal error: bversion.h: No such
>> file or directory
>>  #include "bversion.h"
>>                       ^
>> compilation terminated.'
>> + '[' 1 -ne 0 ']'
>> + exit 1
>>
>> build log is at:
>> https://travis-ci.org/sudipm-mukherjee/parport/jobs/136350824
>>
>> Looks like 6b90bd4ba40b ("GCC plugin infrastructure") is the problem.

I also ran into this and immediately came to look in the linux-next
e-mail discussions, since I was sure this had to be widespread...

> Hi, yes, if you want to be testing the GCC plugins, you'll need the
> gcc plugin headers installed. On Debian and Ubuntu, they can be found
> like this:

...but I think this misses the point completely.  I have my queue of patches
that I regularly test against the daily linux-next.  I have no interest at this
point in time about the gcc plugins.  I just want to fetch linux-next, apply
my patches and for a set of architectures, do an "allmodconfig" and build.

After the plugin commits, I can't even build the native (i386 and x86_64)
allmodconfig arch to build test my work.  And this is on a generic common
distro install.   People may not have admin access on their build machines
so you can't just say ...

> $ apt-cache search gcc | grep plugin-dev
> gcc-5-plugin-dev - Files for GNU GCC plugin development.
> gcc-4.7-plugin-dev - Files for GNU GCC plugin development.
> gcc-4.8-plugin-dev - Files for GNU GCC plugin development.
> gcc-4.9-plugin-dev - Files for GNU GCC plugin development.

...install the above packages.  Just like some of the other features with
dependencies, this needs to warn and self-disable,  It can't be breaking
existing work flows that people rely on.   An example of warn and continue:

Makefile:689: Cannot use CONFIG_KCOV: -fsanitize-coverage=trace-pc is
not supported by compiler

I have locally reverted the three gcc-plugin commits so I can continue to
test my pending work on linux-next, but please do give the above some
consideration vs. forcing everyone else to do the same 3 reverts.

Thanks,
Paul.
--


>
>
> -Kees
>
> --
> Kees Cook
> Chrome OS & Brillo Security
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
