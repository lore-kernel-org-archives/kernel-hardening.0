Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <5759E871.3040706@gmail.com>
Date: Thu, 09 Jun 2016 23:06:41 +0100
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
MIME-Version: 1.0
References: <20160609163408.37fb77b9@canb.auug.org.au>
In-Reply-To: <20160609163408.37fb77b9@canb.auug.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: linux-next: Tree for Jun 9
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thursday 09 June 2016 07:34 AM, Stephen Rothwell wrote:
> Hi all,
>
> News: there will be no linux-next releases on Friday (tomorrow) or
> Monday, so the next release will be next-20160614 on Tuesday.
>
> Changes since 20160608:

While trying to build x86_64 allmodconfig I am getting:
++ dirname ../scripts/gcc-plugin.sh
+ srctree=../scripts
++ gcc -print-file-name=plugin
+ gccplugins_dir=plugin
++ g++ -E -x c++ - -o /dev/null -I../scripts/gcc-plugins -Iplugin/include
+ plugincc='In file included from <stdin>:1:0:
../scripts/gcc-plugins/gcc-common.h:4:22: fatal error: bversion.h: No 
such file or directory
  #include "bversion.h"
                       ^
compilation terminated.'
+ '[' 1 -ne 0 ']'
+ exit 1

build log is at:
https://travis-ci.org/sudipm-mukherjee/parport/jobs/136350824

Looks like 6b90bd4ba40b ("GCC plugin infrastructure") is the problem.


Regards
Sudip
