lib LibShm
  IPC_PRIVATE = 0

  IPC_CREATE = 1000
  IPC_EXCL = 2000

  IPC_RMID = 0

  fun shmget(key : Int32, size : LibC::SizeT, flag : Int32) : Int32
  fun shmat(id : Int32, addr : UInt8*, flag : Int32) : UInt8*
  fun shmdt(addr : UInt8*) : Int32
  fun shmctl(id : Int32, cmd : Int32, shmid_ds : UInt8*) : Int32
end
