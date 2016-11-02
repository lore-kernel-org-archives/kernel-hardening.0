Reply-To: kernel-hardening@lists.openwall.com
From: Marian Marinov <mm-l@yuhu.biz>
Message-ID: <93057ac3-301d-ed5d-405d-93eb4e3deb30@yuhu.biz>
Date: Wed, 2 Nov 2016 05:42:41 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Legitimate use of /proc/PID/mem,maps and smaps
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi guys,
after dirtyCoW me and colleges of mine started discussing different vectors of exploiting applications and we noticed that a lot of the exploits we were discussing relied on /proc/PID/mem or mpas or smaps to be readable by the same user.

We started thinking of legitimate use of these files (lsof, gdb with plugins and valgrind). Are there any other legitimate users of these files, maybe X?

I'm considering writing a patch, which will make sure that nobody, even the owner of the process, can't open these files and only root or users with CAP_DAC_OVERRIDE and/or CAP_SYS_ADMIN can see these files.
For everyone that is not root and lacks DAC_OVERRIDE and SYS_ADMIN the files should not exists.

What do you think about this?

Best regards,
Marian
