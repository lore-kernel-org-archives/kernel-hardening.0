Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
From: manjunatha srinivasan <manjunathan.n@gmail.com>
Date: Wed, 7 Dec 2016 13:16:08 +0530
Message-ID: <CA+xQMzy45NoLqy8XyArT4ZTN1q21zRnjj9VLHz5awmG61eU_9A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Regarding PaX
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi

I am new to PaX.

I have plan to port only PaX (i.e mutual exclusive write/execute
pages) for latest kernel (kernel.org) for x86_64 architectures. From
other place I found patch from
(https://git.m-privacy.de/linux-mprivacy-4.1.git) from branch
'paxonly' for  4.1  kernel. From the commit ID
9474667100c85c944a0d71ede82ef85e3ab502dc (123248 lines).
In other place from https://grsecurity.net/download.php, I can see the
 patch 'grsecurity-3.1-4.8.12-201612062306.patch' .

I don't' know where to start from these places. Please let me know
about information on internals i.e. about code implementation and
related documents of PaX ( i.e. mutual exclusive write/execute
pages.).

Also if want to do of porting PaX (i.e mutual exclusive write/execute
pages) from scratch where can I find internals of it. Is that
information from https://pax.grsecurity.net/ is enough idea for kick
start.
Please let me know the prerequisite knowledge on Linux subsystem like
memory management before starting.

Please let me know any openwall  git repository is  available.

If you feel this not the correct place of asking, please advice where
should I post.


Thanks & Regards
Manjunatha Srinivasan N
