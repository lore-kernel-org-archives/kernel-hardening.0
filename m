Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <5759E871.3040706@gmail.com>
References: <20160609163408.37fb77b9@canb.auug.org.au> <5759E871.3040706@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 9 Jun 2016 15:14:50 -0700
Message-ID: <CAGXu5jJbzUueFvrBJvP3qhprKQ95fZqfgo08VvyG5HETL0a4Sw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: linux-next: Tree for Jun 9
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Linux-Next <linux-next@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Emese Revfy <re.emese@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 9, 2016 at 3:06 PM, Sudip Mukherjee
<sudipm.mukherjee@gmail.com> wrote:
> On Thursday 09 June 2016 07:34 AM, Stephen Rothwell wrote:
>>
>> Hi all,
>>
>> News: there will be no linux-next releases on Friday (tomorrow) or
>> Monday, so the next release will be next-20160614 on Tuesday.
>>
>> Changes since 20160608:
>
>
> While trying to build x86_64 allmodconfig I am getting:
> ++ dirname ../scripts/gcc-plugin.sh
> + srctree=../scripts
> ++ gcc -print-file-name=plugin
> + gccplugins_dir=plugin
> ++ g++ -E -x c++ - -o /dev/null -I../scripts/gcc-plugins -Iplugin/include
> + plugincc='In file included from <stdin>:1:0:
> ../scripts/gcc-plugins/gcc-common.h:4:22: fatal error: bversion.h: No such
> file or directory
>  #include "bversion.h"
>                       ^
> compilation terminated.'
> + '[' 1 -ne 0 ']'
> + exit 1
>
> build log is at:
> https://travis-ci.org/sudipm-mukherjee/parport/jobs/136350824
>
> Looks like 6b90bd4ba40b ("GCC plugin infrastructure") is the problem.

Hi, yes, if you want to be testing the GCC plugins, you'll need the
gcc plugin headers installed. On Debian and Ubuntu, they can be found
like this:

$ apt-cache search gcc | grep plugin-dev
gcc-5-plugin-dev - Files for GNU GCC plugin development.
gcc-4.7-plugin-dev - Files for GNU GCC plugin development.
gcc-4.8-plugin-dev - Files for GNU GCC plugin development.
gcc-4.9-plugin-dev - Files for GNU GCC plugin development.


-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
